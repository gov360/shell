
  【调优课程安排】 6 - 7天时间

前端调优： varnish  缓存加速器  1天
后端调优： redis/memcache      1天
内核调优： 1天
cpu men：1天
磁盘io ： 1天
网络 ： 1天
lamp/lnmp: apache 
mysql ： 1天

python: 练习很重要---数据分析师
python语言： 8天   if   for  while
zabbix: 分布式监控 2天 
saltstack： 分布式配置管理工具 3天

python二次开发

shell 语法 OK， 优点：windows - cygwin， 操作文件、文件夹
	系统管理脚本语言

shell计划任务：
每天给mysql做全备份 mysqldump -A
每个小时增量备份  binlog   mysql -e 'flush logs;'
/home/test/db_bak/


前端调优： varnish  缓存加速器

lamp


用户  ------  访问 apache  -------  mysql
				     nfs服务器 放 音频 视频 图片文件

动态页面
静态页面

数据流向：
  源ip 目的ip
  源mac 目的mac
  协议使用什么
------------------------------------------------------
王佳乐


考试 ：
   机试：
   面试：

钱：
  公司企业面试： 自信、 流利程度

搭建MHA：
manager--conf  --- 切换一次，自动退出，complete删除
ABBB -- node

学习服务：
准备工作：需要准备哪些东西
操作流程：
步骤1：
步骤2
步骤3
步骤4
 步骤.......

多个服务提炼总结：

云笔记：
apache
nginx
nagios
。。。。

小公司： 一个运维： 你
老板：你
方案：文档

6台服务器 java

	负载均衡  tomcat	 mysql：优缺点
	lvs/ nginx/ haproxy/ varnish

  lvs	tomcat	mysql
  lvs   	tomcat	mysql

监控：最重要

自学：

--------------------------------------------------------


用户  ------varnish  访问 apache  -------  mysql
				nfs服务器 放 音频 视频 图片文件


磁盘 web服务器
内存 varnish


varnish—— 商品号6082

  接收请求，动态 or 静态
  如果是动态页面，varnish相当于代理服务器，跳转到web服务器，web 处理动态页面【走mysql】。
  如果是静态页面，varnish先查看本地的内存中是否有数据，如果有，并且数据没有过期，直接返回数据给用户。
				                      如果没有，或者数据已经过期，将请求交给apache进行处理。
 		  web服务器处理完成，将数据返回给varnish，varnish判断是否本地缓存。
  		  varnish将数据返回给用户。


varnish： CDN  内容分发网络  自己做1000w
   CDN公司： 100w
  /var/cdn/GS1
  /var/cdn/GS2
  /var/cdn/GS3
带宽

云服务： 阿里云 腾讯云 金山云 百度云。。。
 kvm
 vmware workstation

 docker： 服务 apache  lvs

IT：
20k以上

python ： 数据分析师40k   400k 1000k

王者荣耀：奖金27个月

静态页面：动态页面 = 8 : 2 or 9 : 1
   

 cdn：  varnish、 nginx= engine x【LB、web】、squid 【小松鼠】
 优 点：
  1 解决线路问题。
  2 解决磁盘I/O问题。

-------------------------------------------------------------------------------------

vcl： varnish control language 

管理varnish的配置文件：
vim /etc/varnish/default.vcl 
启动参数：
vim /etc/sysconfig/varnish   ------> 启动文件/etc/init.d/varnish读取这个文件。


varnishd
At least one of -d, -b, -f, -M, -S or -T must be specified
usage: varnishd [options]
    -a address:port         # HTTP 监听地址及端口
    -b address:port         # backend  后端 web服务器的地址及端口
                                    #    -b <hostname_or_IP>
                                    #    -b '<hostname_or_IP>:<port_or_service>'
    -d                             # debug 打印更多日志信息
    -f file                        # VCL script
    -F                             # Run in foreground
    -h kind[,hashoptions]    # Hash specification
                                        #   -h critbit [default]
                                        #   -h simple_list
                                        #   -h classic
                                        #   -h classic,<buckets>
hash 哈希 散列 【一串固定长度的字符串】：将任意输入，转化为固定长度的字符串。
md5sum
数据检索：人的身份证号，检索人的信息。

    -i identity                  # Identity of varnish instance
    -M address:port        # Reverse CLI destination.
    -n dir                        # varnishd working directory
    -P file                        # PID file
    -p param=value                 # set parameter
    -s kind[,storageoptions]     # 指定数据存储方式
                                 #   -s malloc,<size>    以内存的方式存储
                                 #   -s file,<dir_or_file>,<size>   以硬盘文件方式存储

    -t                           # Default TTL 默认生存时间
    -S secret-file          # Secret file for CLI authentication
    -T address:port      # Telnet 管理地址及端口  telnet IP port
    -V                         # version
    -w int[,int[,int]]      # Number of worker threads 工作线程的数量
                                 #   -w <fixed_count>
                                 #   -w min,max
                                 #   -w min,max,timeout [default: -w2,500,300]
    -u user                  # Priviledge separation user id
    -g group


服务运行： 门

server port : 固定
client port : 随机

ssh 22


receive: 接受请求
lookup： 查询本地缓存 
  hit：   本地缓存中有【命中】
miss：  本地缓存中没有【未命中】
pass：  本地不缓存，varnish当做代理去后端取数据
pipe：  丢弃请求，不进行处理。

fetch：  取源， 获取原始数据。
deliver：提交数据给用户


shell:
函数：有一定功能的对象。能够接受参数

+  -  *  /

function 函数名( )

函数调用：
函数名 CS1 CS2 



string 字符串
object 对象

函数 == 方法


http请求：无状态协议
cookie：  给客户端，客户端访问不需要输入用户名密码，直接登录。
session： 保存到服务器端。 给客户一个sessionid, 客户端。

HTTP协议（HyperText Transfer Protocol，超文本传输协议）是用于从WWW服务器传输超文本到本地浏览器的传输协议。
它可以使浏览器更加高效，使网络传输减少。它不仅保证计算机正确快速地传输超文本文档，还确定传输文档中的哪一部分，
以及哪部分内容首先显示(如文本先于图形)等。

1M ：80 - 100RMB/月
上传：



查看是否命中：
 # vim /etc/sysconfig/varnish
 sub vcl_deliver {
     if (obj.hits > 0) {
      set resp.http.X-cache = "HITS";
 } else {
      set resp.http.X-cache = "MISS";
 }
      return (deliver);
 }



 针对不同的页面，指定缓存策略：
  jpg png bmp gif....

 css jsp 页面架构文件。

 目标：
 架构文件：缓存一天

 gif 缓存3分钟

 jpg 缓存2分钟


自学http协议：apache nginx
ls


缓存多个网站：
 # vim /etc/sysconfig/varnish

backend haoyi {
  .host = "10.1.1.3";
  .port = "80";
 }

backend g {
  .host = "10.1.1.4";
  .port = "80";
 }


 sub vcl_recv {

if (req.http.host ~ "^www.vfast.com") {
    set req.backend = haoyi;
}else if (req.http.host ~ "^www.rongxin.com") {
    set req.backend = g;
}



varnish： 缓存后端网站，加速网站的返回速度。
缓存静态页面。
动态页面还是要去数据库中找。


