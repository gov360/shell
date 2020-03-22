备份与还原（恢复）

1、备份分类
	冷备份
	热备份

冷备份：关闭服务，确保备份集的一致性。
热备份：不需要关闭服务，关闭部分功能--写入功能（通过加写锁来拒绝写入操作，但不影响客户端的读操作）


2、冷备份


	
2.1	关闭服务
2.2	备份--物理拷贝（cp /var/lib/mysql/*）
	
	备份全库：
	备份部分库
	备份部分表
	
	备份全库：
		【关闭服务】[root@MySQL ~]# service mysqld stop
		【备 份】	[root@MySQL mysql]# cp -rp /var/lib/mysql/  /opt/
		【模拟数据丢失】 [root@MySQL mysql]# rm -fr *
		【还原数据】[root@MySQL mysql]# service mysqld stop
			[root@MySQL mysql]# mkdir /var/lib/mysql
			[root@MySQL mysql]# cp -rp /opt/mysql/*  /var/lib/mysql/
			
			[root@MySQL mysql]# chown mysql.mysql -R *        【更改文件所有者和所属组为mysql】
	
	备份部分库（库中的表为myisam有效）：
		[root@MySQL DB1]# service mysqld stop
		[root@MySQL mysql]# cp -pr DB1/  /opt/
		# mysql -p123
		> drop database DB1;    【删除DB1库】
		> quit;
		[root@MySQL DB1]# cp -pr /opt/DB1/    /var/lib/mysql/	//恢复的时候，如果没有客户端访问，可以不用关服务，直接拷贝回来；
								如果有客户端访问，则需要关闭数据库
				
	备份部分表（适用于myisam表）：练习


	
3、热备份
	不关服务，加锁，写锁，一致性备份
	工 具：	mysqldump
	用 法：
		Usage: mysqldump [OPTIONS] database [tables]
		OR     mysqldump [OPTIONS] --databases [OPTIONS] DB1 [DB2 DB3...]
		OR     mysqldump [OPTIONS] --all-databases [OPTIONS]
		
			myisam      -x；--lock-all-tables		
			innodb	    --single-transaction 事务锁
				   -A； --all-databases	备份的是所有库
	
myisam表：		
	备份全库：
		mysqldump -x -A >/opt/all.sql
	部分库：
		mysqldump -x --databases DB1 DB2 >/opt/db.sql
	部分表
		mysqldump -x DB1 t1 > /opt/db1_t1.sql
	
	恢复：
		全库恢复：
			# mysql < /opt/all.sql
		部分库：
			# mysql < /opt/db.sql
		部分表：
			# mysql DB1 < /opt/db1_t1.sql

	innodb:
		全库备份：
		mysqldump --single-transaction -A >/opt/all.sql
	
		全库恢复：
			# mysql < /opt/all.sql

	如果既有myisam表也有InnoDB表，加锁时用--single-transaction方式加锁。
	备份：
		[root@bogon mysql]# mysqldump --single-transaction -A > /opt/all.sql
	恢复：
		[root@bogon mysql]# mysql < /opt/all.sql

4、备份的策略
	每周日 00:00:00  全库备份
	周一：	只备份当天的数据    
	周二：	只备份当天的数据
	...
	周日：...
	
	增量备份：只备份自上一个备份日之后的新增数据
	备份策略：周日全库备份，周一至周日进行增量备份

	增量备份基于binlog（二进制）日志的备份。会记录对数据的增删改操作。
	每天产生一个binlog日志：
		重启MySQL服务
		> flush logs;

	开启binlog日志功能：
	[root@localhost ~]# vim /etc/my.cnf 

	0 0 * * * mysql -uroot -h127.0.0.1 -p123 -e "flush logs"
	
	
	实验：
		1、先去进行全库备份
		2、编辑配置文件，开启二进制日志功能
		[root@localhost ~]# vim /etc/my.cnf 
			log_bin=binlog
			log_bin_index=binlog.index
		3、插入数据  -->flush logs 刷新日志，模拟一天新增数据
		4、插入数据  -->flush logs 模拟第二天的数据
		...
		5、备份    直接拷贝binlog   拷贝当前不用的binlog
		6、模拟数据丢失   rm -fr /var/lib/mysql/*
		7、准备恢复
			先要关闭二进制日志记录功能   进入到配置文件，注释掉那两行
		[root@localhost ~]# vim /etc/my.cnf 
			# log_bin=binlog
			# log_bin_index=binlog.index
			恢复时，先恢复全库备份，然后逐日恢复
		8、恢复后，开启二进制日志。
		[root@localhost ~]# vim /etc/my.cnf 
			log_bin=binlog
			log_bin_index=binlog.index

实时备份
	mysql复制特性  ---AB复制
	
	master来承担增删改的操作-->写入到binlog日志中-->slave  IO线程过来拉取binlog并且写入到relay log中继日志中，-->slave 
				SQL线程来读取中继日志并将其执行(应用)到mysql中
	
搭建AB复制：
	[root@localhost ~]# vim /etc/my.cnf
	master
	1）确定自己为主
	2）开启binglog日志
	3）授权给从机器上的某个用户  replication salve

	server_id=1
	log_bin=binlog
	log_bin_index=binlog.index

	从 slave
	[root@localhost ~]# vim /etc/my.cnf
	1）确定自己为从
	2）主是谁，以哪个用户的身份去主上面拉取数据，拉过来后写到哪里（relay log）


	server_id=2
	master_user="repl"
	master_password="123"
	master_host="192.168.19.248"
	relay_log=/var/lib/mysql/relay_log
	relay_log_index=/var/lib/mysql/relay_log.index
	
	
管理：
主的上面了解master的二进制日志及位置号：
mysql> show master status\G
*************************** 1. row ***************************
            File: binlog.000002
        Position: 366
    Binlog_Do_DB: 
Binlog_Ignore_DB: 
1 row in set (0.00 sec)
	
	
从的上面了解复制信息：
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event		//等待事件发生
                  Master_Host: 192.168.19.248		//主的IP
                  Master_User: repl			//复制用户用户名
                  Master_Port: 3306			//主的端口号
                Connect_Retry: 60			//连接重试事件 秒
              Master_Log_File: binlog.000002		//当前主的二进制文件
          Read_Master_Log_Pos: 366		//slave读取到的主二进制日志文件的位置号
               Relay_Log_File: relay_log.000004		//本机上中继日志文件名
                Relay_Log_Pos: 508			//本机上中继日志记录到的位置号
        Relay_Master_Log_File: binlog.000002	//中继过来的二进制日志文件
             Slave_IO_Running: Yes			//io 线程工作正常
            Slave_SQL_Running: Yes		//SQL 线程工作正常
 	  Exec_Master_Log_Pos: 366		//执行到的位置好		



如果出现错误：
	首先：
		主：	show master status\G
			记下来二进制日志以及位置号
		slave:
CHANGE MASTER TO
  MASTER_HOST='192.168.19.248',
  MASTER_USER='repl',
  MASTER_PASSWORD='123',
  MASTER_PORT=3306,
  MASTER_LOG_FILE='刚记下来的二进制日志文件名',
  MASTER_LOG_POS=4,			//刚记下来的位置号
  MASTER_CONNECT_RETRY=10;		
		


查看主上面的连接信息：
mysql> show processlist\G
*************************** 1. row ***************************
     Id: 3
   User: repl
   Host: 192.168.19.251:45556
     db: NULL
Command: Binlog Dump
   Time: 1489
  State: Has sent all binlog to slave; waiting for binlog to be updated
   Info: NULL
*************************** 2. row ***************************
     Id: 4
   User: root
   Host: localhost
     db: NULL
Command: Query
   Time: 0
  State: NULL
   Info: show processlist
2 rows in set (0.00 sec)


查看从上面的连接信息：
mysql> show processlist\G



*************************** 1. row ***************************
     Id: 1
   User: system user
   Host: 
     db: NULL
Command: Connect
   Time: 1529
  State: Has read all relay log; waiting for the slave I/O thread to update it	//SQL线程
   Info: NULL
*************************** 2. row ***************************
     Id: 2
   User: system user
   Host: 
     db: NULL
Command: Connect
   Time: 1667		
  State: Waiting for master to send event			//IO线程
   Info: NULL
	


互为主从：      keepalived    --->ＭＨＡ　　访问量上千万级别


	
内联结：
Select A.Name, B.Hobby from A, B where A.id = B.id
Select A.Name from A INNER JOIN B ON A.id = B.id

外左联结
Select A.Name from A Left JOIN B ON A.id = B.id
外右联结
Select A.Name from A Right JOIN B ON A.id = B.id		
	
			
		
		
				
