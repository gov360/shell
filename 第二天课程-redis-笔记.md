
varnish 前端web页面的加速——【网络加速器】


redis： 针对后端数据库优化。
  nosql 非关系型数据库，   sql：结构化查询语言
     键值型数据库： key - value
内存型：所有数据都存放在内存中。

mysql: 表， 表与表之间建立联系，  关系型数据库。  oracle   sql-server   db2



web	redis  - redis:slave1 - redis:slave2
	mysql  - B
               - B

程序研发编写程序：控制去数据库调取数据的流程。
    web 先取redis中查询数据，如果redis中有数据，直接返回给用户，
			     如果没有，去mysql中获取数据，如果没有获取数据，返回错误码。
							  如果获取到数据，在redis中存放一份。
    如果mysql中有数据修改，需要在redis中更新修改操作。


mysql: 事务，具有原子性，一个完整的操作 innodb ib_logfile事务日志  失败：roll_back  成功：commit



源码包-----rpm【系统环境，需要依赖。。。】

redis: 6379 端口号


运维：
    搭建环境
    维护数据库良好运转


jsp  .net  php
LAMP: 如何让redis 与 php建立联系。使得php页面能够调用redis。

1 webserver搭建lamp架构：
   安装httpd
   安装php

2 webserver 使php能够调用mysql、redis模块
   phpize 编译
   ./configure
   make
   
   /usr/local/php/lib/php.ini:
   extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20131226"
   extension=redis.so
   extension=mysql.so

3 重启apache
查看模块加载是否成功。




=========================================================================================
常规配置：
启动服务：
./redis-server /etc/redis.conf
关闭服务：
./redis-cli shutdown

redis绑定监听端口：
bind 10.1.1.1 127.0.0.1

redis密码：
requirepass qwer-1234-asdf

./redis-cli
-h 	ip/host
-p	port
-a	密码

保证redis安全：
1 使用非常复杂的密码
2 redis 只允许内网中的有限服务器进行连接。iptables

keypass密码保存工具: 
跳板机/堡垒机/黑洞机/   ----- 连接所有服务器

主从复制：
mysql:
主：
  binlog 记录增删改操作
从：
  IO 线程  replication slave   记录到relaylog
  SQL 线程 执行relaylog中的新命令。
show slave status\G

高级运维 / dba

开发：java  c c++ C# php .net h5 python
	开发框架， 改 + 抄

数据库开发：
淘宝： 修改内核的mysql。

oracle




配置：

主：
vim /etc/redis.conf
bind 10.1.1.1 127.0.0.1

从：
vim /etc/redis.conf
bind 10.1.1.3 127.0.0.1
slaveof 10.1.1.1 6379
masterauth qwer-1234-asdf

重启：
./redis-cli shutdown
./redis-server /etc/redis.conf


数据持久化：
redis 两种数据持久化方式【数据持久化：从内存中保存到磁盘】
第一种：
快照： snapshotting， 将当前redis中的所有数据状态保存到本地文件。  
保存快照命令： save、 bgsave
快照保存文件：dump.rdb
规则：redis.conf
#   save ""
save 900 1   # 900秒内如果有一次修改操作那么触发save命令。
save 300 10  # 300秒内有大于等于10次修改，那么触发save命令。
save 60 10000 # 60 秒内有超过10000次修改，那么触发save命令。

if 修改超过10000 && time <=60:
   save
elif 修改超过10 && time <= 300:
   save
elif 修改超过1 && time <= 900;
   save
else 
   不操作

伪码

关闭 snapshoting ：
save ""
#save 900 1
#save 300 10
#save 60 10000


第二种：
AOF： append only file
不停的向一个文件中追加修改数据库的命令。

优点，能够节省资源，保证数据快速写入磁盘。但是会多些很多冗余信息。对于冗余信息，我们可以使用命令：
bgrewriteaof

appendonly no  【开启改为yes】
appendfilename "appendonly.aof"
# appendfsync always   每一次收到修改命令就马上写入aof文件。
appendfsync everysec   每秒将数据写入aof文件
# appendfsync no       不去自动触发，完全依赖OS，不推荐使用。


备份还原策略
备份方法：
cp dump.rdb/appendonly.aof  /备份目录/redis_tim.bak

mysql:
一周全备份：
每天增量备份：mysql -u user -ppassword -e"flush logs"


运维  dba  测试   =》》 辅助研发 将产品顺利上线提供服务给用户。


cpu监控： 11个监控项
内存
网卡
硬盘
swap
风扇转速
温度

服务：
  port
  ps aux | grep ...
  12345
  54321

日志监控：
  message.log  [grep awk]


==================================================================================

系统资源优化：


