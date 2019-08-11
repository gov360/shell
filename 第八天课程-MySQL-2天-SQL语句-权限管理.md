

1、SQL语句的分类

2、MySQL的权限管理

3、MySQL的API

4、存储引擎



1、SQL语句的分类
	DDL：data define language   数据定义语句
		create/alter/drop/truncate/rename
	
	DML: data manipulation language  数据操作语句
		insert/update/delete/select
	
	DCL: data control language数据控制语言
		grant/revoke

2、MySQL的权限管理
	权限：控制用户是否能够登陆MySQL，以及登陆上之后能做什么。
	
	2.1MySQL权限的处理逻辑
		用户名+密码
		用户名+密码+host：你是谁（用户名）+密码+host（你从哪来）
			user1 + 123  192.168.19.1
			user1 + 123  192.168.19.2
	2.2创建用户
		2.2.1	mysql> create user 'user2'@'192.168.19.1' identified by '123';
		2.2.2	mysql> grant all on *.* to 'user3'@'192.168.19.1' identified by '123';	//创建用户并且赋权
		2.2.3	mysql> set password for 'user3'@'192.168.19.1'= password('123456');	//设置密码

		查看MySQL中有没有用户名叫user1的用户：
			mysql> select user,host,password from mysql.user where user='user1';
		
		查看user1@192.168.19.1用户的权限：
			mysql> show grants for 'user'1@'192.168.19.1'；
		
		收回权限：
		mysql> revoke all on *.* from user3@192.168.19.1;

		查看都有哪些连接：
		mysql> show processlist;
+----+-------+--------------------+-------+---------+------+-------+------------------+
| Id | User  | Host               | db    | Command | Time | State | Info                |
+----+-------+--------------------+-------+---------+------+-------+------------------+
|  5 | root  | localhost          | mysql | Query   |    0 | NULL  | show processlist |
| 11 | user3 | 192.168.19.1:56738 | NULL  | Sleep   |  121 |       | NULL             |
+----+-------+--------------------+-------+---------+------+-------+------------------

		踢掉某个连接（杀死连接的id号）：
		mysql> kill 11;
	
	2.3有哪些权限：

	2.4 删除用户
		mysql> drop user 'user3'@'192.168.19.1','user1'@'192.168.19.1',user2@192.168.19.1;

	2.4 特殊的用户--可以使用模糊主机的用户
		mysql> grant all on *.* to user1@'%' identified by '123';	//授权给从任何一台主机上连过来的use1用户

	
	2.5、安全加固          随时密码存放路径：/root/.mysql_secret
	3.2	将历史命令扔进黑洞：
	[root@MySQL ~]# ln -s /dev/null ~/.mysql_history

	3.3	删除mysql.db表的数据
	mysql> select * from mysql.db where db='test'\G
	mysql> truncate table mysql.db;
	

	2.6、管理员口令丢失
	2.6.1修改配置文件，增加一行:
	skip-grant-table

	2.6.2[root@MySQL ~]# mysqld_safe --skip-grant-tables --skip-networking &
	mysql> update mysql.user set password=password('123') where user='root';
	mysql> flush privileges;
	
	2.6.3
		 mysql_secure_installation   初始化数据库
	
	
3.MySQL的API         application interface
	bash与MySQL的接口：
	[root@MySQL mysql]# mysql -uroot -h127.0.0.1 -p  -e "create database DB1;"
	
	php与MySQL的接口：mysql_connect()

	[root@MySQL html]# mysql -uroot -p class < fangyuan.sql		导入点数据



4、存储引擎
	myisam    innodb
	
myisam 3.23~5.5版本之后，默认；  读写速度快，缺点数据不可靠，没有自己的日志文件；支持表锁。

表锁：
	读锁：	
		读锁和读锁之间是互相兼容的；读锁跟写锁之间是排斥的；
	写锁：
		当用用户DML操作时，会将整张表锁住，其他用户编辑该表的其他行，也不行。

	会影响当大量的插入的操作。如果应用极少出现写入操作，可有优先选择myisam表。
	

myisam表对象文件结构：
	t1.frm 		表结构文件
	 t1.MYD 		表数据文件
	 t1.MYI		表索引

myisam存储引擎的特性：
	支持表锁	并发写入性能查，读取和写入速度快
	最大存储能力256T
	

InnoDB	支持事物，数据即索引，索引即数据
	ACID
	A 原子性
	C 一致性    开始前一致的状态、结束后一致的状态
	I 隔离性     
	D 持久性	
mysql> create table t1(id int);

mysql> alter table t1 engine=innodb;

InnoDB文件结构：
t1.frm	表结构文件
ibdata1	数据文件/索引   ---系统表空间

行锁：
	支持的并发大

InnoDB特性：
	支持事物
	单表最大存储能力64   T
	支持行锁   
	读性能好，写性能相对较差    
	MVCC  多版本并发控制系统

InnoDB特有的日志文件：
	redo log  重做日志缓存  --->磁盘
	ib_logfile0  ib_logfile1	5M一个     用于保证数据的持久性
	master线程：每隔1秒钟，会将重做日志缓存写入磁盘
			innodb_flush_log_at_trx_commit=1

脏数据
	

索引：
	给表加索引：
		alter table t1 add key(id);
	id  name
	加索引时要选择那个具有高选择性的列。
		select * from t1 where name=zhangwei;

	mysql> show index from chengji\G	//查询表中索引的信息
	
	
	
						
课堂要求：
会创建用户
会给用户赋权
MySQL安全加固
会发布php页面

了解myisam表InnoDB表的文件结构
了解锁 读 写



第三天课程：备份和还原
第四天课程：MHA    


	
		

