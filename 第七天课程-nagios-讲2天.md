nagios：监控


概念监控项目：
	监控服务器的存活状态
	监控服务的运行状态
	监控资源使用状况

软件：
	nagios
	cacti
	zabbix

3、nagios是什么
	是一款开源的IT基础设施监控软件。交换机、路由器、服务器、各种网络服务软件。
	监控平台（支持web页面的）
4、特点
	开源免费
	可是实现监控各种网络服务软件（http/mysql/ftp/nfs...）
	监控本机及远程主机的状态
	支持邮件报警
	允许用户编写监控插件（监控一个项目，脚本）
	web页面

5、安装
	
yum install httpd php-* gcc glibc glibc-common gd -y
useradd  nagios
tar -xf nagios-4.0.8.tar	
./configure --prefix=/usr/local/nagios

make all
make install
make install-init
make install-commandmode
make install-config
make install-webconf


service httpd restart
service nagios restart

Apache中关于nagios页面的配置文件：/etc/httpd/conf.d/nagios.conf

6、实现对nagios本机的监控
6.1	nagios文件结构

bin  执行文件
etc  
	cgi.cfg		cgi的配置文件，修改了nagios的管理员用户名（nagios）
	htpasswd.users	存放认证网页的用户、密码文件     htpasswd -cm /usr/local/nagios/etc/htpasswd.users nagios
	nagios.cfg	nagios的主配置文件，不要修改
	resource.cfg	存放nagios的变量的文件。比如$USER1$表示插件存放路径
	objects
	commands.cfg  	命令的配置文件，可以定义nagios使用的命令
	localhost.cfg     定义监控哪些项目
	timeperiods.cfg	定义监控时间段
	contacts.cfg 	定义联系人
	templates.cfg  模板，定义命令的模板、监控项的模板、时间段、联系人模板。

		

	printer.cfg     
	windows.cfg
	switch.cfg  


include  存放包含到nagios中的文件，类似与Apache的/etc/httpd/conf.d
libexec  存放的是插件

sbin  cgi程序

share  存放web页面

var	存放日志文件、锁文件等


nagios实现监控的过程：
默认打开nagios之后，就支持对本机的监控，为什么呢？
1）localhost.cfg中已经定义了对本机的监控
2）通过commands.cfg中的命令来调用插件  check_host_alive(check_ping)
3) 再通过timeperiods.cfg来确定监控的时间段    24x7
4) 如果触发报警，联系contacts.cfg中定义的联系人


7、实现对一台远程主机的监控
[root@localhost ~]# vim /usr/local/nagios/etc/objects/localhost.cfg 

################## host 192.168.19.114 ######################

define host {
        host_name               BJ_CNC_19.114
        alias                   First
        address                 192.168.19.114

        check_command           check-host-alive
        check_period            24x7
        check_interval          2
        max_check_attempts      1

        notification_options    d,u,r
        notification_period     24x7
        notification_interval   30
        contact_groups          admins
}



8、监控远程主机的两个服务--web和MySQL

实验步骤：

1、被监控主机上192.168.19.114安装mysql，并添加用户。
[root@MySQL ~]# yum install mysql-server -y
[root@host html]# mysql

mysql>  create user 'nagios'@192.168.19.156 identified by '123'；
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

2、在监控主机（192.168.19.156）上测试
[root@localhost libexec]# mysql -unagios -h192.168.19.114 -p123 -e "show databases" 
+----------------------+
| Database             |
+----------------------+
| information_schema   |
| test                 |
+----------------------+
[root@localhost libexec]# ./check_mysql 
MySQL is UP!

3、写mysql监控插件
[root@localhost ~]# cd /usr/local/nagios/libexec/
[root@localhost ~]# vim check_mysql
# !/bin/bash
mysql_user=nagios
mysql_host=192.168.19.114
mysql_passwd=123
mysql -u${mysql_user} -h${mysql_host} -p${mysql_passwd} -e "show databases" >/dev/null 2>1
if [ $? -eq 0 ];then

        echo    "MySQL is UP!"
        exit    0
        else
        echo "MySQL is DOWN!"
        exit 2
fi

[root@localhost libexec]# ./check_mysql 	
MySQL is UP!  		执行脚本显示UP 显示DOWN 说明有错误

4、插件有了，现在去定义一个nagios命令来调用这个插件
[root@localhost ~]# vim /usr/local/nagios/etc/objects/commands.cfg 

define command{
        command_name   check_mysql
        command_line    $USER1$/check_mysql

}

5、nagios命令有了，现在去修改localhost.cfg
[root@localhost ~]# vim /usr/local/nagios/etc/objects/localhost.cfg
[root@localhost libexec]# /etc/init.d/nagios restart
Running configuration check...
Stopping nagios:. done.
Starting nagios: done.

[root@localhost ~]# vim /usr/local/nagios/etc/objects/localhost.cfg 

############## service Apache 192.168.19.114 ################

define service{
        host_name               BJ_CNC_19.114
        service_description     apache

        check_command           check_http
        check_period            24x7
        normal_check_interval          2
        retry_check_interval           1
        max_check_attempts             3

        notification_options    w,c,u,r
        notification_period     24x7
        notification_interval   30
        contact_groups          admins
}
################## service mysql  192.168.19.114 ################

define service{
        host_name               BJ_CNC_19.114
        service_description     MySQL

        check_command           check_mysql
        check_period            24x7
        normal_check_interval          2
        retry_check_interval           1
        max_check_attempts             3

        notification_options    w,c,u,r
        notification_period     24x7
        notification_interval   30
        contact_groups          admins
}

6、手动刷新nagios界面，可以看到mysql这个服务的监控信息



nagios怎样知道通过什么颜色来表现当前服务的运行状态---通过命令（插件）执行结果的返回值：

返回值		状态		颜色
0		运行		绿色
1		警告		黄色
2		严重警告		红色
3		未知		橘色
	

9、实现对本地资源的监控--内存


	9.1)写插件--使用现成的，拷贝到/usr/local/nagios/libexec  
	9.2)定义命令    vim etc/object/commands.cfg  
	9.3)监控         		localhost.cfg
	9.4）重启ｎａｇｉｏｓ　并测试

10、监控远程主机上的资源--内存
	1）需要在被监控主机上安装nrpe，并且运行该服务（xinetd）
	2）在被监控主机上定义check_memory命令
	3）监控主机上安装nrpe插件，并定义check_nrpe命令
	4）在监控主机上设置localhost.cfg 文件，定义监控项
	
实现监控的过程：
	nagios发出监控需求（监控被监控主机上的内存使用情况）-->check_nrpe命令传达给被监控主机上的nrpe daemon，-->调用check_nrpe命令执行check_memory插件-->产生执行结果-->nrpe daemon反馈给监控主机上的check_nrpe插件-->将数据交给nagios-->显示出来


	

11、设置告警邮件
	设置监控信息（localhost.cfg）--》触发报警-->mutt写邮件-->msmtp第三方工具（需要认证--指定邮件服务器）-->邮件服务器-->投递邮件到收件人的邮箱账号

1）安装设置mutt
[root@Naigos nagios]# yum install mutt -y
vim /etc/Muttrc
set sendmail="/usr/local/bin/msmtp"
set from="xjl_vfast@163.com"
set realname="xiaojingling"

2）安装设置mutt
安装：
1010  tar -jxf msmtp-1.4.30.tar.bz2 
 1011  cd msmtp-1.4.30
 1012  ./configure 
 1013  make && make install

设置：
vim /usr/local/msmtprc	
account default
host    smtp.163.com
port    25
from    xjl_vfast@163.com
tls     off
auth    login
user    xjl_vfast@163.com
password 20170314WT
logfile /tmp/msmtp.log

3）设置联系人
define contact{
        contact_name                    nagiosadmin             ; Short name of user
        use                             generic-contact         ; Inherit default values from generic-contact template (defined above)
        alias                           Nagios Admin            ; Full name of user

        email                           xjl_vfast@163.com  

4）设置发送邮件的命令
define command{
        command_name    notify-host-by-email
        command_line    /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /usr/bin/mutt -s "** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **" $CONTACTEMAIL$
        }

# 'notify-service-by-email' command definition
define command{
        command_name    notify-service-by-email
        command_line    /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$\n" | /usr/bin/mutt -s "** $NOTIFICATIONTYPE$ Service Alert: $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **" $CONTACTEMAIL$
        }

5）设置localhost.cfg文件
把之前所有的监控项中的IP改成现在的被监控主机的IP

6）重启nagios


12、模板文件   templates.cfg
	
	






