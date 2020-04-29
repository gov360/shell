# zabbix安装分为服务端和客户端 **安装程序不同**
服务端操作
```
  cat <<EOF > /etc/yum.repos.d/zabbix.repo
  [zabbix]
  name=Zabbix Official Repository - \$basearch
  baseurl=https://mirrors.aliyun.com/zabbix/zabbix/4.0/rhel/7/\$basearch/
  enabled=1
  gpgcheck=1
  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
  [zabbix-non-supported]
  name=Zabbix Official Repository non-supported - \$basearch
  baseurl=https://mirrors.aliyun.com/zabbix/non-supported/rhel/7/\$basearch/
  enabled=1
  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
  gpgcheck=1
  EOF
  curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX     -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
  curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX-A14FE591     -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
  yum install zabbix-server-mysql
  yum install zabbix-web-mysql
  yum install httpd mariadb mariadb-server php php-mysql
  systemctl enable mariadb
  systemctl enable httpd
  systemctl start httpd
  systemctl start mariadb
  mysql_secure_installation 
shell> mysql -uroot -p<password>
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> create user 'zabbix'@'localhost' identified by '<password>';
mysql> grant all privileges on zabbix.* to 'zabbix'@'localhost';
mysql> quit;
  zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
  zcat /usr/share/doc/zabbix-proxy-mysql*/schema.sql.gz | mysql -uzabbix -p zabbix
  vi /etc/zabbix/zabbix_server.conf 
  systemctl start zabbix-server
  systemctl status zabbix-server
  vi /etc/httpd/conf.d/zabbix.conf 
  systemctl restart httpd
  rm -rf /etc/alternatives/zabbix-web-font 
  ln -s /usr/share/fonts/dejavu/simkai.ttf /etc/alternatives/zabbix-web-font
  ls /var/www/html/
  rpm -ql httpd
  rpm -qc httpd
  rpm -qd httpd
  ls /var/www/
  rpm -ql httpd
  echo hello >> /var/www/html/index.html
```  
客户端操作  
```
  cat <<EOF > /etc/yum.repos.d/zabbix.repo
  [zabbix]
  name=Zabbix Official Repository - \$basearch
  baseurl=https://mirrors.aliyun.com/zabbix/zabbix/4.0/rhel/7/\$basearch/
  enabled=1
  gpgcheck=1
  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
  [zabbix-non-supported]
  name=Zabbix Official Repository non-supported - \$basearch
  baseurl=https://mirrors.aliyun.com/zabbix/non-supported/rhel/7/\$basearch/
  enabled=1
  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
  gpgcheck=1
  EOF
  curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX-A14FE591     -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
  curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX     -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
  yum install zabbix-agent
  vi /etc/zabbix/zabbix_agentd.conf 
  systemctl restart zabbix-agent
  systemctl status zabbix-agent
```
[如果要进一步缓解服务端获取数据压力，可以增加代理端做数据采集，服务端做存储和数据展示]  
本文没有用到代理端操作