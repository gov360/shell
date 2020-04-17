# 二进制安装mariadb**两台机器**
```
useradd -r -d /data/mysqldb -s /sbin/nologin mysql  
id mysql  
ln -s /usr/local/mariadb-10.3.22-linux-x86_64/ mysql   
cp mysql/support-files/mysql.server /etc/init.d/mysql  
chkconfig --add /etc/init.d/mysql  
echo PATH=/usr/local/mysql/bin:$PATH >> /etc/profile.d/mysql.sh  
. /etc/profile.d/mysql.sh    
cd /usr/local/mysql/  
scripts/mysql_install_db --user=mysql --datadir=/data/mysqldb    
vi /etc/my.cnf   **指定数据目录，修改sock路径到tmp下**  
service mysql restart  
mysql_secure_installation
```  
## 测试两台机器的服务
`[登录]|[建库]|[建表]|[建用户]`
### 停止两台机器的mariadb
主库IP `[192.168.1.20]`  
从库IP `[192.168.1.17]`  
* 1 主库配置修改  [引用](https://mariadb.com/kb/en/setting-up-replication/ "官方文档")
```
vi /etc/my.cnf.d/mariadb.cnf  
[mariadb]  
log-bin  
server-id=1   
log-basename=master1  
```
* 启动主库  
登录执行  
```
CREATE USER 'slave'@'%' IDENTIFIED BY 'slavepasswd';
GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%';
```  
* 锁定主库，并保持会话。
```
FLUSH TABLES WITH READ LOCK; 
```

* 2 配置从库  
vi /etc/my.cnf.d/mariadb.cnf 
```  
server-id=2  
``` 
* 启动从库  
**显示主库状态**`需要记录log-file 名&log-pos ID`
```
SHOW MASTER STATUS;
```  
`[主库锁定状态下备份主库]`  
* 主库备份  
```
mysqldump -uroot -p -A >all.sql  
```  
* 从库恢复  
```
mysql -uroot -p <all.sql
```
* 解锁主库  
```  
UNLOCK TABLES;  
```
`从库启动同步任务`
``` 
CHANGE MASTER TO
  MASTER_HOST='192.168.1.20',
  MASTER_USER='slave',
  MASTER_PASSWORD='slavepasswd',
  MASTER_PORT=3306,
  MASTER_LOG_FILE='node1-bin.000001',
  MASTER_LOG_POS=484509,
  MASTER_CONNECT_RETRY=10;
```  
** MASTER_HOST**`[主库的IP]`  
** MASTER_USER** `[主库的用户]`  
** MASTER_PASSWORD** `[主库的密码]`  
** MASTER_LOG_FILE** `[主库状态显示的文件]`    
** MASTER_LOG_POS** `[主库状态的ID]` 
* 链接主库测试  
```
mysql -h 192.168.1.20 -uslave -p
```  
* 启动从服务  
```
START SLAVE;
```  
* 查看从服务状态  
```
SHOW SLAVE STATUS\G
```  
--------------------------
## 从服务优化  [引用](https://mariadb.com/kb/en/gtid/#setting-up-a-new-slave-with-an-empty-server "官方文档")
* 从库启用GTID标示  `[全局唯一标示]`
```
stop slave;  
CHANGE MASTER TO MASTER_USE_GTID = slave_pos;                 
START SLAVE;
```  
