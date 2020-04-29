# zabbix安装分为服务端和客户端 **安装程序不同**
服务端操作
```
  32  cat <<EOF > /etc/yum.repos.d/zabbix.repo
   33  [zabbix]
   34  name=Zabbix Official Repository - \$basearch
   35  baseurl=https://mirrors.aliyun.com/zabbix/zabbix/4.0/rhel/7/\$basearch/
   36  enabled=1
   37  gpgcheck=1
   38  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
   39  [zabbix-non-supported]
   40  name=Zabbix Official Repository non-supported - \$basearch
   41  baseurl=https://mirrors.aliyun.com/zabbix/non-supported/rhel/7/\$basearch/
   42  enabled=1
   43  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
   44  gpgcheck=1
   45  EOF
   47  curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX     -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
   48  curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX-A14FE591     -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
   49  yum install zabbix-server-mysql
   50  yum install zabbix-web-mysql
   55  yum install httpd mariadb mariadb-server php php-mysql
   56  systemctl enable mariadb
   57  systemctl enable httpd
   58  systemctl start httpd
   59  systemctl start mariadb
   60  mysql_secure_installation 
shell> mysql -uroot -p<password>
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> create user 'zabbix'@'localhost' identified by '<password>';
mysql> grant all privileges on zabbix.* to 'zabbix'@'localhost';
mysql> quit;
   70  zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
   71  zcat /usr/share/doc/zabbix-proxy-mysql*/schema.sql.gz | mysql -uzabbix -p zabbix
   72  vi /etc/zabbix/zabbix_server.conf 
   73  systemctl start zabbix-server
   74  systemctl status zabbix-server
   75  vi /etc/httpd/conf.d/zabbix.conf 
   76  systemctl restart httpd
   77  rm -rf /etc/alternatives/zabbix-web-font 
   78  ln -s /usr/share/fonts/dejavu/simkai.ttf /etc/alternatives/zabbix-web-font
   79  ls /var/www/html/
   80  rpm -ql httpd
   81  rpm -qc httpd
   82  rpm -qd httpd
   83  ls /var/www/
   84  rpm -ql httpd
   86  echo hello >> /var/www/html/index.html
```  
客户端操作
```
   39  cat <<EOF > /etc/yum.repos.d/zabbix.repo
   40  [zabbix]
   41  name=Zabbix Official Repository - \$basearch
   42  baseurl=https://mirrors.aliyun.com/zabbix/zabbix/4.0/rhel/7/\$basearch/
   43  enabled=1
   44  gpgcheck=1
   45  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
   46  [zabbix-non-supported]
   47  name=Zabbix Official Repository non-supported - \$basearch
   48  baseurl=https://mirrors.aliyun.com/zabbix/non-supported/rhel/7/\$basearch/
   49  enabled=1
   50  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
   51  gpgcheck=1
   52  EOF
   53  curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX-A14FE591     -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
   54  curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX     -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
   55  yum install zabbix-agent
   56  vi /etc/zabbix/zabbix_agentd.conf 
   57  systemctl restart zabbix-agent
   58  systemctl status zabbix-agent
```
[如果要进一步缓解服务端获取数据压力，可以增加代理端做数据采集，服务端做存储和数据展示]  
本文没有用到代理端操作