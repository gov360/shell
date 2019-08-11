
Nginx课程安排
第一天大纲：
  【Nginx安装】

  【基本配置】

  【反向代理】

  【虚拟主机】

  【URL重写】

  【防 盗链】

  【限 速】

  【lnmp 】

  【优 化】


Nginx与Apache的比较（作为web服务器）

Nginx优于Apache
轻量级。采用C编写，不论是系统资源开销还是CPU使用率上表现好很多。
10000并发只占2.5M内存资源。
抗并发。Nginx处理请求是异步非阻塞的，多个连接（万级别）对应一个进程；
Apache是阻塞调用，多进程模型，一个连接对应一个进程。静态请求处理能力3倍于Apache。

配置简单，神一样的配置.


Apache优于Nginx
首当其冲的是稳定

Rewrite功能比Apache强大
模块多，丰富的特性。

更好的支持PHP，处理动态请求有优势

nginx是什么

nginx的应用

nginx特点

nginx的基础概念--master和worker

1、nginx是什么
	高性能的web服务器软件（Apache、iis），10000并发请求只占用2.5M内存；支持50000并发
	反向代理服务器软件：代理的是服务器
	负载均衡器
	邮件服务器（postfix）

2、nginx应用（www.netcraft.com）
	俄罗斯最大的门户网站
	淘宝、网易、百度、新浪...

3、nginx的特点
	性能高，官方数据：50000并发   30000
	开销低，10000并发请求只占用2.5M内存
	可移植性好
	C语言开发
	代理功能强大，负载均衡（七层）

4、nginx的基础概念

  master进程

  worker进程

	回顾：Apache有哪些工作模式（MPM）
		prefork	预派生模型
		worker	线程模型
		event	进线程混合模型（不保证好使，正在测试）
			特点：
				1、预先生成进程（线程）
				2、线程占用资源少，多个线程公用一个进程的内存资源。
				3、开启长连接（keepalived）
	nginx：
		event  进线程混合模型，即使开启长连接，那么会有专门的线程来处理长连接请求，不会等待长连接超时时间。

	worker进程：工作进程。用于处理网络事件。每个worker进程都是独立的。一个连接只能在一个worker进程中被处理。
	master：管理worker进程;监听80端口，接受请求并且分配请求；平滑升级nginx。

cd /usr/local/nginx-1.7.8
conf	配置文件
html	页面文件
logs	日志
sbin	可执行文件

启动服务
/usr/local/nginx-1.7.8/sbin/nginx
停止服务
kill -9 pid
重新加载
/usr/local/nginx-1.7.8/sbin/nginx –s reload
验证配置文件
/usr/local/nginx-1.7.8/sbin/nginx –t

5、安装nginx  把文件用rz 拷贝到 /usr/src/目录下
 # yum install lrzsz -y
 # cd /usr/src/
 # rz
 # chmod 755 /usr/src/*   给所有文件执行权限
 # ls

【源码包安装的 nginx 重启】
#/usr/local/nginx/sbin/nginx -s reload
或者
#  killall nginx
#  /usr/local/nginx/sbin/nginx

方法一安装：
[root@localhost src]# ls
debug    nginx-1.5.1         nginxd            php_cgi
kernels  nginx-1.5.1.tar.gz  nginx_install.sh  spawn-fcgi-1.6.3-1.el5.i386.rpm
[root@localhost src]# ./nginx_install.sh
开启nginx服务
# /etc/init.d/nginxd start
nginx start				 [ OK ]
[root@localhost nginx]# lsof -i:80
COMMAND  PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
nginx   9028   root    6u  IPv4  36278      0t0  TCP *:http (LISTEN)
nginx   9029 nobody    6u  IPv4  36278      0t0  TCP *:http (LISTEN)


方法二安装：
[root@Nginx nginx-1.11.3]# yum install gcc pcre-devel zlib-devel -y
[root@Nginx nginx-1.11.3]#./configure --prefix=/usr/local/nginx
[root@Nginx nginx-1.11.3]# make && make install
运行nginx ：
[root@Nginx sbin]# /usr/local/nginx/sbin/nginx
[root@Nginx sbin]# lsof -i:80


6、发布网页
相关设置字段：
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
server {
        listen       80;
        server_name  localhost;
        location / {			相当于Apache的DocumentRoot，文档根目录
            root   html;		
            index  index.html index.htm;
        }
1）准备网页
yum安装一般在 /usr/share/nginx/html/
源码安装一般在/usr/local/nginx/html
[root@Nginx html]# mv index.html index.html.bak
[root@Nginx html]# vim index.html
[root@Nginx html]# cat index.html
Hello,nimei!
[root@Nginx html]# ls
50x.html  index.html  index.html.bak

2）测试：
elinks http://localhost --dump
Hello,nimei!

7、主配置文件


8、虚拟主机
实验环境：
OS：rhel6.7
Nginx：1.5.1
客户端：192.168.19.249
Nginx：192.168.19.{253，254}


基于端口虚拟主机：

1、修改配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf

	  worker_processes  3;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;

    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }   
        }   
         server {
          listen       8080;
          server_name  localhost;

          location / {
              root   www;
              index  index.html index.htm;
          }
        }
        }

2、增加8080端口对应的根目录www及首页文件
	mkdir /usr/local/nginx/www
	echo 8080 > /usr/local/nginx/www/index.html
3、重启nginx服务
	[root@Nginx nginx]# killall -s HUP nginx
4、客户端测试
	elinks http://localhost --dump
	elinks http://localhost:8080 --dump

虚拟主机(多网站)
在http模块中，最后大括号上添加include vhost/*.conf;扩展加载配置
因为vhost目录指定的是当前目录，所以我需要在/usr/local/nginx-1.7.8/conf/下创建vhost目录

mkdir vhost
vim vhost/www.vfast.com.conf
server {
     listen       80;
     server_name  www.vfast.com;
     charset koi8-r;

     #access_log  logs/host.access.log  main;

     location / {
         root   /work/web/www.vfast.com;
         index  index.html index.htm;
     }

     #error_page  404              /404.html;

     error_page   500 502 503 504  /50x.html;
     location = /50x.html {
         root   html;
     }
 }

./nginx –t 验证配置文件
./nginx –s reload 重新加载配置文件



基于域名虚拟主机

1、配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
  worker_processes  3;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;

    keepalive_timeout  65;

    server {
        listen       80;
        server_name  www.bb.com;

        location / {
            root   html;
            index  index.html index.htm;
        }   
        }   
         server {
          listen       80;
          server_name  www.cc.com;

          location / {
              root   www;
              index  index.html index.htm;
          }
        }
        }

2、域名解析
[root@host ~]# vim /etc/hosts
192.168.19.253        www.a.com
192.168.19.253        www.b.com

3、网页制作
[root@Nginx nginx]# echo "www.a.com" > /usr/local/nginx/html/index.html
[root@Nginx nginx]# echo "www.b.com" > /usr/local/nginx/www/index.html

4、重启服务
[root@localhost etc]# /etc/init.d/nginx restart

5、客户端测试
[root@host ~]# elinks http://www.a.com --dump
[root@host ~]# elinks http://www.b.com --dump



基于IP虚拟主机

1、配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
	worker_processes  3;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;

    keepalive_timeout  65;

    server {
        listen    192.168.19.156:80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }   
        }   
         server {
          listen       192.168.19.150:80;
          server_name  localhost;

          location / {
              root   www;
              index  index.html index.htm;
          }
        }
        }

2、查看服务监听端口—此时监听的是从本机上所有网卡过来的http请求
[root@Nginx nginx]# netstat -tlnp | grep 80
tcp        0      0 0.0.0.0:80        0.0.0.0:*         LISTEN      25183/nginx

3、添加一块网卡（别名），并重启nginx
[root@Nginx nginx]# ifconfig eth0:1 192.168.19.254
[root@Nginx nginx]# killall -s HUP nginx

4、重启服务，查看监听端口—此时监听12.1.1.2和12.1.1.3网卡进来的请求
[root@Nginx nginx]# netstat -tlunp | grep 80
tcp        0      0 192.168.19.253:80            0.0.0.0:*              LISTEN      25060/nginx         
tcp        0      0 192.168.19.254:80            0.0.0.0:*              LISTEN      25060/nginx

5、客户端测试
[root@Nginx nginx]# elinks http:// 192.168.19.253--dump
   www.bb.com
[root@Nginx nginx]# elinks http:// 192.168.19.254--dump
   www.cc.com

=============================================================
=============================================================



下午课程：

9、URL重写
	www.a.com   -->apache  -->  ^/$    http://www.b.com -->
	实验环境：	nginx   19.245
			apache  19.248
			clent   19.248
	客户端请求www.a.com(245),将请求通过url重写交给248（www.b.com）.

	URL重写是web服务器的功能。


环境：
13.1.1.1   主机名 www.a.com  扮演nginx提供web和客户端角色
13.1.1.200 主机名www.b.com

为了交代清楚，故让学生先看一下默认首页

1）nginx配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  www.a.com;
        location / {
            root   html;
            index  index.html index.htm;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}

2）结合解析
vim /etc/hosts
echo “127.0.0.1  www.a.com” >>/etc/hosts

此时使用浏览器，输入www.a.com即可得到nginx提供的web页面


3）nginx重写，将访问www.bb.com的请求交给www.cc.com
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
worker_processes  3;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;


    sendfile        on;

    keepalive_timeout  65;

    server {
        listen       80;
        server_name  www.bb.com;

        location / {
         #   root   html;
         #   index  index.html index.htm;
        rewrite ^/$ http://www.cc.com;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
        }
        }

4）客户端修改域名解析
	vim /etc/hosts
	127.0.0.1   www.a.com
	13.1.1.200  www.b.com

5）设置13.1.1.200的web服务
	/etc/init.d/httpd restart
	echo “rewrite” > /var/www/html/index.html

6）客户端测试
	在nginx浏览器上输入www.a.com得到rewrite



10、防盗链

1、先做盗链服务器
	<html>
        <body>
                <a href="http://192.168.18.254/a.png">盗链测试</a>
        </body>
	</html>
注释：
	<html></html>说明这是一个网页。告诉浏览器这个网页的开始和结束。包括以下两个元素：
	<head></head>之间的内容是网站的标题
	<body></body>之间定义的即使网页的信息，也就是浏览器中呈现出来的用户看到的网页的效果。也就是说这是网页的主体，
即body在HTML语言中<a>---单词anchor（抛锚泊船，锚的意思）用于定义一个链接href，单词HyperText reference（超文本引用）

2、nginx服务器上防盗链：
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  www.a.com;

        location / {
            root   html;
            index  index.html index.htm;
        }
        location ~*.(gif|jpg|png|swf|flv)$ {		#匹配图片格式
                valid_referers none blocked *.baidu.com;	#valid_referers定义允许倒链的
                        if ($invalid_referer) {		#判断如果是不允许倒链的，我们返回403
                                return 403;  #403错误表示服务器收到请求，但拒绝提供页面
                        }
                }
        }
}

释义：
none 代表没有referer
blocked 代表有referer但是被防火墙或者是代理给去除了		


11、反向代理
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
	反向代理代理的是服务器。www.a.com
	正向代理代理的是客户端，客户端需要设置使用哪个代理服务器。

	245   反向代理服务器		248 客户端       真实服务器（源服务器） 247


	客户端-->反向代理服务器-->真实服务器
	真实服务器-->反向代理服务器-->客户端

	最基本的反向代理：  proxy_pass  http://192.168.19.248;
	端口映射：proxy_pass  http://192.168.19.248:8080;

	实现真实服务器日志记录真正客户端的ip：
	1、修改反向代理服务器的配置文件
		 proxy_set_header    X_Real_IP $remote_addr;
            	 proxy_set_header    X-Forward-For  $proxy_add_x_forwarded_for;
	2、修改真实服务器的配置文件的日志格式
	LogFormat "%{X-Forward-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined


worker_processes  3;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;
worker_processes  3;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  www.bb.com;

        location / {
         #   root   html;
         #   index  index.html index.htm;
        proxy_pass  http://192.168.19.156;

#       rewrite ^/$ http://www.cc.com;
        }

        location ~* .(gif|jpg|png|swf|flv)$ {
        valid_referers none blocked *.baidu.com;

        if ($invalid_referer) {
        return 403;
 }
 }
       error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
        }
        }



12、nginx限速

实验环境：
客户端：13.1.1.200
nginx服务器：13.1.1.1

实验说明：
本实验涉及三个部分，
 1、从下载开始即限速；
 2、下载一定大小后开始限速；
 3、避免下载软件恶意（多进程）下载造成服务器压力多大

实验一：下载开始即限速

 1、先来看一下不限速的现在速率

在nginx文档根目录下创建大文件：
[root@Nginx conf]# dd if=/dev/zero of=/usr/local/nginx/html/bigfile bs=1M count=100
在客户端上测试下载速率
[root@Lvs1 opt]# wget http://192.168.19.253/bigfile
--2016-11-09 22:29:14--  http://13.1.1.1/bigfile
正在连接 13.1.1.1:80... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度：104857600 (100M) [application/octet-stream]
正在保存至: “bigfile”
100%[======================================>] 104,857,600 44.0M/s   in 2.3s    

  2、配置nginx配置文件限速并重启nginx
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
worker_processes  3;
events {
    worker_connections  1024;
}

    include       mime.types;
worker_processes  3;
events {
    worker_connections  1024;
}
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen      80;
        server_name  www.bb.com;
        location / {
         #   root   html;
         #   index  index.html index.htm;
         limit_rate 100k;

#       rewrite ^/$ http://www.cc.com;
        }

        location ~* .(gif|jpg|png|swf|flv)$ {
        valid_referers none blocked *.baidu.com;

        if ($invalid_referer) {
        return 403;
 }      
 }      
       error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }   
        }   
        }

  3、测试限速功能
[root@Lvs1 opt]# wget http://192.168.19.253/bigfile
--2016-11-09 22:35:54--  http://13.1.1.1/bigfile
正在连接 13.1.1.1:80... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度：104857600 (100M) [application/octet-stream]
正在保存至: “bigfile”
 0% [                                ] 406,120     99.6K/s


实验二：文件下载到一定大小后限速的设置及测试
nginx配置
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
	设置下载到90M之后，按照每秒100k的速率下载。

worker_processes  3;
events {
    worker_connections  1024;
}
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;    
    server {
        listen      80;
        server_name  www.bb.com;
        location / {
         #   root   html;
         #   index  index.html index.htm;
         limit_rate_after 90m;
         limit_rate 100k;

#       rewrite ^/$ http://www.cc.com;
        }

        location ~* .(gif|jpg|png|swf|flv)$ {
        valid_referers none blocked *.baidu.com;

        if ($invalid_referer) {
        return 403;
 }      
 }      
       error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }   
        }   
        }

客户端测试：
[root@Lvs1 opt]# rm -fr bigfile
[root@Lvs1 opt]# wget http://13.1.1.1/bigfile
--2016-11-09 22:37:57--  http://13.1.1.1/bigfile
正在连接 13.1.1.1:80... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度：104857600 (100M) [application/octet-stream]
正在保存至: “bigfile”

[==================================>    ] 94,576,640  27.9M/s
[==================================>    ] 94,883,840  21.1M/s
[==================================>    ] 94,883,840  17.3M/s
[==================================>    ] 94,883,840  14.6M/s
[==================================>    ] 95,191,040  12.4M/s
[==================================>    ] 95,191,040  11.0M/s
[==================================>    ] 95,191,040  9.86M/s eta



实验三：防止恶意下载造成服务器压力多大
 1、模拟恶意软件恶意下载
客户端脚本：
#!/bin/bash

for i in `seq 1 10`
 do
        wget http://192.168.19.253/bigfile >/dev/null &
 done

解释：模拟客户端开启10个进程下载服务器资源

执行脚本，ps aux | grep wget 可以看到10个wget进程

 2、限制每个源IP最多开三个下载
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
配置文件：
worker_processes  3;
events {
    worker_connections  1024;
}
    include       mime.types;
    default_type  application/octet-stream;

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
        limit_conn_zone $binary_remote_addr zone=tom:300k;
    server {
        listen      80;
        server_name  www.bb.com;
        location / {
         #   root   html;
         #   index  index.html index.htm;
         limit_rate_after 90m;
         limit_rate 100k;
        limit_conn tom 3;
#       rewrite ^/$ http://www.cc.com;
        }

        location ~* .(gif|jpg|png|swf|flv)$ {
        valid_referers none blocked *.baidu.com;
        if ($invalid_referer) {
        return 403;
 }      
 }      
       error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
   }   
   }
   }

再次执行恶意下载脚本，ps aux | grep wget，看到只有3个wget进程
root     18505  0.1  0.1  10244  1488 pts/0    S    23:12   0:00 wget http://13.1.1.1/bigfile
root     18507  0.1  0.1  10244  1492 pts/0    S    23:12   0:00 wget http://13.1.1.1/bigfile
root     18514  0.1  0.1  10244  1488 pts/0    S    23:12   0:00 wget http://13.1.1.1/bigfile
root     18517  0.0  0.0   6052   768 pts/0    S+   23:12   0:00 grep wget



13、lnmp架构和动态页面
	lamp   网站发布架构   Linux + Apache +MySQL +php
			      Linux + nginx+MySQL+php

	静态页面：页面是写好的，客户端请求页面，服务器直接返回
	动态页面：客户端请求动态页面，服务器先执行脚本，将脚本执行的结果反馈给客户端	   php  时间

	Apache+php    cgi   fcgi  php-fpm :php以服务的形式运行，9000端口  5.4之后php-fpm  
									 5.4  

基于端口的虚拟主机配置格式：
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
worker_processes  3;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;


    sendfile        on;

    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }   
        }   
         server {
          listen       8080;
          server_name  localhost;

          location / {
              root   www;
              index  index.html index.htm;
          }
        }
        }


================================================================
===============================================================



第二天上午课程：

13、lnmp架构和动态页面
	lamp   网站发布架构   Linux + Apache +MySQL +php
				Linux + nginx+MySQL+php

	静态页面：页面是写好的，客户端请求页面，服务器直接返回
	动态页面：客户端请求动态页面，服务器先执行脚本，将脚本执行的结果反馈给客户端   php  时间

	Apache+php    cgi   fcgi  php-fpm :php以服务的形式运行，9000端口  5.4之后php-fpm  
									 5.4之前  spawn-fcgi  ---把php制作成服务

	nginx也好Apache也好，它怎样判断收到的请求是动态页面请求还是一个静态页面请求：
		看的是请求URL的后缀。
		静态页面：.html
		动态页面：.php
		www.a.com      

	nginx擅长静态页面处理是Apache3倍
	Apache擅长动态页面处理  

发布动态页面：
	一、安装php-* mysql-server msyql -y
	[root@localhost html]# yum install php-* mysql-server mysql -y
    	1、安装spawn-fcgi工具
	[root@localhost src]# rpm -ivh spawn-fcgi-1.6.3-1.el5.i386.rpm
 	2、使用php_cgi脚本来启动管理php服务
	[root@localhost src]# ./php_cgi start
	[root@localhost src]# ./php_cgi restart
	[root@localhost src]# ./php_cgi stop
	3、修改nginx的配置文件开启动态页面的支持
	[root@localhost ~]# cd /usr/local/nginx/conf/
        [root@localhost conf]# vim /etc/nginx.conf

 	location ~ \.php$ {
            root           html;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  /usr/local/nginx/html/		    $fastcgi_script_name;
            include        fastcgi_params;
        }

	[root@localhost html]# mv index.html index.php
	[root@localhost html]# vim index.php

       <?php
        echo date('y-m-d h:i:s',time())
	?>
	4、客户端测试
	[root@host opt]# elinks http://192.168.19.156 --dump
   	17-06-01 08:52:02



 14、优化：
	连接：
		nofile     一个程序最多同时打开1024个文件
		通过修改操作系统中nofile的限制，实现让nginx可以处理更多的并发连接。
		ulimit -SHn 65535         临时修改的方式
		vim /etc/rc.local	  永久修改（该文件是系统启动时最后加载的一个脚本文件）

	绑定nginx进程：
		进程争夺CPU资源
		实现worker进程固定到一个cpu核心上，充分利用CPU资源来运行nginx
	压缩：

	缓存：
		告知客户端浏览器缓存多长时间
		参数：expires  10m；
			天：d
			年：y
			时：h
			秒: s

================================================================
================================================================

下午课程：

15、nginx负载均衡   rr   wrr   ip_hash   

实验环境：
	负载均衡器：192.168.19.245
	客户端：192.168.19.248
	RS1:192.168.19.241
	RS2：192.168.19.242

	nginx作为负载均衡器的特点：
		基于OSI七层--应用层的分发（nginx可看到应用层上的包头信息）
		看到：
			请求的URL（url_hash）

			rr
			wrr
			ip_hash(lvs--sh)


	动静分离（根据客户端请求的页面，静态页面交给后端nginxweb服务器，动态页面交给后端Apache服务器）
	客户端使用的浏览器类型
	IP地址分发（判断客户端所处的地域）
	根据主机头分发（根据域名分发）
	发布jsp页面
	nginx负载均衡的高可用

	实现分发：
		反向代理+upstream模块

	反向代理：
	客户端将请求发送给反向代理服务器，代理服务器将请求转发给后端的真实（源）服务器，源服务器解析请求，处理请求，
将数据发送给代理服务器，代理再转发给客户端。upstream模块实现分发的功能。

1、nginx反向代理服务器配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf

实现rr分发：
	[root@localhost ~]# cd /usr/local/nginx/conf/
        [root@localhost conf]# vim /etc/nginx.conf
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
            proxy_pass  http://www;		//所有的请求交给www
        }

}
        upstream www {				//定义请求www的分发规则：默认算法为rr
                server 192.168.19.241;
                server 192.168.19.242;
        }
}

2、设置RS服务器页面
RS1上的页面配置
[root@host opt]# cd /var/www/html
[root@host html]# vim index.html

3、客户端测试
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS2 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS2 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS2 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS2 ####



1、nginx反向代理服务器配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf

实现wrr分发：
	[root@localhost ~]# cd /usr/local/nginx/conf/
        [root@localhost conf]# vim /etc/nginx.conf
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
            proxy_pass  http://www;
        }

}
        upstream www {
                server 192.168.19.241 weight=3;		//weight权重
                server 192.168.19.242;
        }
}


2、客户端测试
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS2 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS2 ####

处理会话一致性的问题：memcache/redis						

1、nginx反向代理服务器配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf

实现ip_hash分发：
	根据客户端源ip的hash值来分发请求---同一个客户端的请求固定分发到一台rs上。
	缺点：可能会造成某台服务器负载过大，其他服务器空闲的情况
        [root@localhost ~]# cd /usr/local/nginx/conf/
        [root@localhost conf]# vim nginx.conf
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
            proxy_pass  http://www;
        }

}
        upstream www {
                ip_hash;			//基于ip_hash算法分发
                server 192.168.19.241;
                server 192.168.19.242;
        }
}


2、客户端测试
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### RS1 ####

动静分离
	客户端发出httpd请求包（包头信息    URL），
		客户单请求的URL：www.a.com，对于Apache来说，客户端请求的后缀名.php结尾
					对于nginx来说，客户单请求的后缀名是.html结尾
	就可以根据后缀名来判断客户端请求的是动态页面还是静态页面。

	nginx动静分离就是根据客户端请求的URL后缀名来判断请求的是动态还是静态页面。


实验环境：
os:rhel6.7  x86_64
nginx-1.5  

IP规划：
rs1     241
rs2	242
nginx	245
client	248

在rs2上配置动态页面的支持：
	yum install php-* mysql-server mysql -y
	service httpd restart		//重新加载配置文件（php模块）
	cd /var/www/html
	vim index.php

	<?php
       	 	echo date('y-m-d h:i:s',time());
	?>

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  localhost;

	location ~ \.html$ {			//nginx收到一个以.html结尾的请求后，交给www
            proxy_pass  http://www;
        }

	location ~ \.php$ {			//nginx收到一个以.php结尾的请求后，交给php
            proxy_pass  http://php;
        }

    }

        upstream www {				
                server 192.168.19.241;
        }
        upstream php {
                server 192.168.19.242;
        }
}

客户端测试：
[root@localhost ~]# elinks http://192.168.19.156/index.php --dump
   17-05-30 12:28:51
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### html test ####
[root@localhost ~]# elinks http://192.168.19.156/index.php --dump
   17-05-30 12:29:21
[root@localhost ~]# elinks http://192.168.19.156 --dump
   #### html test ####
[root@localhost ~]# elinks http://192.168.19.156/index.php --dump
   17-05-30 12:33:21



URL_hash:
	www.a.com   -->www.a.com/index.html
			-->www.a.com/index.php
			www.a.com/1.html   --计算客户端请求的URL的hash值。同一个URL的hash值是一样。
			www.a.com/2.html

	url_hash：根据客户端请求的url的hash值来决定将请求交给后端的哪台rs（缓存服务器）

	作用：提高web缓存命中率

	打补丁：
 1025  cd /usr/src/
 1027  tar -zxf Nginx_upstream_hash-0.3.1.tar.gz
 1029  cd nginx_upstream_hash-0.3.1/
 1031  cat README 				//查看readme文件，根据指导来操作
 1032  cd /usr/src/nginx_install/		//进入到nginx的安装包存放目录
 1034  cd nginx-1.5.1				//进入到nginx的解压包目录
 1035  patch -p0 < /usr/src/nginx_upstream_hash-0.3.1/nginx.patch 	//打补丁
 1036  ./configure --prefix=/usr/local/nginx/ --add-module=/usr/src/nginx_upstream_hash-0.3.1/		//加入模块
 1037  make && make install		//编译、安装
 1038  echo $?
 1040  /etc/init.d/nginxd restart

      [root@localhost ~]# cd /usr/local/nginx/conf/
      [root@localhost conf]# vim nginx.conf
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  localhost;
        location / {
            proxy_pass  http://www;
        }
        }
    upstream www {
        hash    $request_uri;			//使用url_hash算法分发
        server  192.168.19.241;
        server  192.168.19.242;
}

}


用到的脚本：
创建rs1上的页面：
[root@host html]# rm -rf index.html
[root@host html]# ls
[root@host html]# vim html.sh

#!/bin/bash
for i in `seq 1 10`
        do
                echo "RS1_$i.html" > $i.html
        done

[root@host html]# chmod u+x html.sh
[root@host html]# ./html.sh


创建rs2上的页面：
[root@host html]# rm -rf index.html
[root@host html]# ls
[root@host html]# vim html.sh

#!/bin/bash
for i in `seq 1 10`
        do
                echo "RS2_$i.html" > $i.html
        done

[root@host html]# chmod u+x html.sh
[root@host html]# ./html.sh

客户端测试脚本：
[root@localhost ~]# for i in `seq 1 10`; do elinks http://192.168.19.156/$i.html --dump; done
   RS1_1.html
   RS1_2.html
   RS1_3.html
   RS2_4.html
   RS2_5.html
   RS2_6.html
   RS2_7.html
   RS2_8.html
   RS2_9.html
   RS2_10.html

[root@localhost ~]# for i in `seq 1 10`; do elinks http://192.168.19.156/$i.html --dump; done
   RS1_1.html
   RS1_2.html
   RS1_3.html
   RS2_4.html
   RS2_5.html
   RS2_6.html
   RS2_7.html
   RS2_8.html
   RS2_9.html
   RS2_10.html

================================================================
================================================================


第三天课程：

上午课程：
nginx负载均衡通过反向代理+upstream模块
rr
wrr
ip_hash
url_hash
动静分离

反向代理：客户端不知道访问的是哪一台服务器，但是能返回给客户端正常的请求
正向代理：客户端访问的是真实web服务器或其他业务服务器ip地址

在Nginx中的默认Proxy是只能对后面Real Server做端口转发的，而不能做域名转发。如果想使用Nginx对后端是同一IP、同一端口 转发不同的域名则需要配置Nginx Proxy。
 这个是因为默认情况下：
 proxy_set_header Host $proxy_host;
 这样就等于前端输入域名后到nginx负载这里直接转换成IP进行转发了。
 于是我们需要修改proxy_set_header的参数。
 proxy_set_header Host $http_host;

nginx默认负载调度算法为rr（轮询）

基于客户端浏览器分发：
user_agent

Firefox -->firefox
elinks  -->elinks
如果无法判断浏览器类型，让它去找192.168.19.150

1、nginx服务器的修改配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf

worker_processes  3;
events {
        worker_connections   1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  localhost;
        location / {
                if ( $http_user_agent ~* "firefox" )  {
                proxy_pass      http://html;
        }
                if ( $http_user_agent ~* "elinks" )  {
                proxy_pass      http://php;
        }
                proxy_pass      http://192.168.19.150;
        }
        }
        upstream html {
        server 192.168.19.157;
}
        upstream php {
        server 192.168.19.114;
}
}


2、客户端测试

在浏览器输入192.168.19.156 可以访问到静态页面
#### html test ####

在终端中用 elinks http://192.168.19.156 --dump 可以看到动态页面

[root@host ~]# elinks http://192.168.19.156 --dump
   17-05-30 10:48:05
[root@host ~]# elinks http://192.168.19.156 --dump
   17-05-30 10:48:06
[root@host ~]# elinks http://192.168.19.156 --dump
   17-05-30 10:48:07
[root@host ~]# elinks http://192.168.19.156 --dump
   17-05-30 10:48:08
[root@host ~]# elinks http://192.168.19.156 --dump
   17-05-30 10:48:09




基于主机头的分发：
	基于域名(域名的虚拟主机)的分发。
		www.aa.com   --> html页面
		www.bb.com   --> php 页面
1、nginx服务器的修改配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
worker_processes  3;
events {
        worker_connections   1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  www.aa.com;
        location / {
                proxy_pass      http://html;
        }
        }
   server {
        listen       80;
        server_name  www.bb.com;
        location / {
                proxy_pass      http://php;
  }
  }
        upstream html {
        server 192.168.19.157;
}
        upstream php {
        server 192.168.19.114;
}
2、客户端设置解析
[root@host ~]# vim /etc/hosts
192.168.19.156   www.aa.com
192.168.19.156   www.bb.com

3、客户端测试
[root@host ~]# elinks http://www.aa.com --dump
   #### html test ####
[root@host ~]# elinks http://www.bb.com --dump
   17-05-30 11:12:16
[root@host ~]# elinks http://www.aa.com --dump
   #### html test ####
[root@host ~]# elinks http://www.bb.com --dump
   17-05-30 11:12:26
[root@host ~]# elinks http://www.aa.com --dump
   #### html test ####
[root@host ~]# elinks http://www.bb.com --dump
   17-05-30 11:12:30



基于IP地址的分发：
	IP地址库-->确定客户端是哪个省份的。
实验环境：
  上海客户端：192.168.19.114
  北京客户端：192.168.19.156
  反向代理服务器：192.168.19.156
  源服务器1：192.168.19.157	  提供页面 ”BJ web server”
  源服务器2：192.168.19.155	  提供页面 ”SH web server”
  源服务器3：192.168.19.114	  提供页面 “PHP动态时间页面”（注：提供IP地址库没有的其它IP）

1、nginx服务器的修改配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf
worker_processes  3;
events {
        worker_connections   1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  www.aa.com;
        location / {
                proxy_pass      http://$geo;
        }
        }
   geo $geo {
        default      ZZ;
        192.168.19.157/32   BJ;
        192.168.19.155/32   SH;
  }
        upstream ZZ {
        server  192.168.19.114;
}
        upstream BJ {
        server 192.168.19.157;
}
        upstream SH {
        server 192.168.19.155;
}
}

2、设置web服务器的页面

源服务器1：192.168.19.157 提供的页面 BJ web server
[root@host ~]# vim /var/www/html/index.html
#### BJ web server ####

源服务器2：192.168.19.155 提供的页面 SH web server
[root@host ~]# vim /var/www/html/index.html
#### SH web server ####

源服务器3：192.168.19.114 提供的页面 PHP动态页面（注：提供IP地址库没有的其它IP）
[root@host ~]# vim /var/www/html/index.php
 	<?php
        echo date('y-m-d h:i:s',time())
	?>


3、客户端测试
访问源IP：192.168.19.156
[root@host ~]# elinks http://192.168.19.156 --dump
   #### BJ web server ####

访问源IP：192.168.19.155
[root@lenovo ~]# elinks  http://192.168.19.156 --dump
   ### SH web server ###

访问源IP：192.168.19.114
[root@host ~]# elinks http://192.168.19.156 --dump
   17-05-30 11:58:44

================================================================
================================================================


16、发布JSP页面（网站）


JSP页面是用java页面写成的，它是一种动态页面。tomcat来发布JSP页面。tomcat是一款Apache旗下的开源软件，一款web软件。

用Java写的页面：
		漂亮
		更加安全

发布页面的架构：
		lamp     lnmp     LTMJ--发布jsp页面


1）   安装软件包
	tomcat    
		解压   -C  /usr/local/tomcat1
		运行tomcat：
			进入到安装目录下bin目录下，    ./startup.sh           关闭：./shutdown.sh
	mysql
		yum install mysql-server mysql -y   
		运行MySQL
	jdk	（java运行环境）
		软件包默认已经安装


================================================================


下午课程：

2）	图形化管理工具
vim .../conf/tomcat-user.xml
<role rolename="manager-gui"/>
<user username="tomcat" password="123456" roles="manager-gui"/>
	关闭、启动（重启）tomcat服务
	地址栏输入：192.168.19.241:8080--->点击MANAGER APP-->输入用户名密码登陆-->管理窗口-->stop/start/reload/undeploy(慎用)




发布JSP网站—bookmanager系统网站

1、安装mysql服务端和客户端，检查jdk的版本（默认已安装）并启动mysql服务
[root@host bookmanage]# yum install mysql-server mysql -y
[root@host bookmanage]# /etc/init.d/mysqld start

2、把bookmanager 拷贝到/usr/src/目录下，并使用unzip解压缩
[root@host src]# rz

[root@host src]# ls
apache-tomcat-8.0.0-RC10  apache-tomcat-8.0.0-RC10.tar.gz  bookmanage.tar.gz  debug  kernels
[root@host src]# unzip bookmanage.tar.gz
[root@host src]# ls
apache-tomcat-8.0.0-RC10         bookmanage         debug
apache-tomcat-8.0.0-RC10.tar.gz    bookmanage.tar.gz    kernels
[root@host src]#

3、进到解压目录bookmanager 查看redme文件
[root@host src]# cd bookmanage
[root@host bookmanage]# ls
bookManage.sql  doc  readme  readme~  src  WebRoot
[root@host bookmanage]# cat readme
#mysql
>create database bookmanage;
>exit
# mysql -u root -p bookmanage < bookManage.sql

4、进入mysql，创建数据库，导入数据
[root@host bookmanage]# mysql
mysql> create database bookmanage;
Query OK, 1 row affected (0.00 sec)
mysql> exit
Bye

5、将要发布的页面（WebRoot）拷贝到tomcat的webapp中并改名book（随意）
[root@host bookmanage]# cp -r WebRoot/ /usr/local/tomcat/tomcat/webapps/book

6、测试访问页面
在浏览器输入192.168.19.157:8080/book



二、实现客户端输入域名www.a.com 可以访问到图书管理系统。通过nginx的url重写来实现，也可以通过nginx反向代理来实现。

1、nginx服务器的修改配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf

worker_processes  3;
events {
        worker_connections   1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  www.a.com;
        location / {
                rewrite         ^/$     http://192.168.19.157:8080/book;
        }
        }
}
[root@localhost ~]# /etc/init.d/nginx restart
[root@localhost ~]# cd /usr/local/nginx/html/
[root@localhost html]# ls
50x.html  a.jpg  bigfile  html  index.html  index.php
[root@localhost html]# mv index.html index.html.bak
[root@localhost html]# mv index.php index.php.bak

2、修改nginx服务器的host文件
vim /etc/hosts 添加192.168.19.156   www.a.com

3、测试访问页面
在浏览器输入www.a.com 或者 192.168.19.156 回车


================================================================

6）tomcat多实例
单进程多线程

8005
8009
8080
tomcat 是单进程多线程的服务。所以对生产环境中多个U的服务器来说是非常浪费资源的，一个进程只使用一个U，所以其他U就会空闲，
解决办法是安装多个tomcat 软件（需要改启动，关闭脚本端口，配置文件默认端口），这样多个tomcat就可以跑在不同的U，服务器资源利用率就高了。

1、拷贝一个tomcat，名称设为tomcat2
[root@host ~]# cd /usr/local/tomcat/
[root@host tomcat]# ls
tomcat
[root@host tomcat]# cp -r tomcat tomcat2
[root@host tomcat]# ls
tomcat  tomcat2

2、更改tomcat2的端口号
三个端口号分别“+10”，查看tomcat监听的端口号：

[root@host tomcat2]# vim conf/server.xml
<Server port="8015" shutdown="SHUTDOWN">
  <Connector port="8090" protocol="HTTP/1.1"
   <Connector port="8019" protocol="AJP/1.3" redirectPort="8443" />

3、启动tomcat2
[root@host tomcat2]# bin/startup.sh

4、验证tomcat1 和tomcat2有没有运行
[root@host tomcat2]# netstat -tlunp | grep java

 tcp      0    0 ::ffff:127.0.0.1:8005       :::*           LISTEN      8172/java           
 tcp      0    0 :::8009                          :::*           LISTEN      8172/java           
 tcp      0    0 ::ffff:127.0.0.1:8015       :::*           LISTEN      10390/java          
 tcp      0    0 :::8080                          :::*           LISTEN      8172/java           
 tcp      0    0 :::8019                          :::*           LISTEN      10390/java          
 tcp      0    0 :::8090                          :::*           LISTEN      10390/jav

5、通过nginx的rewrite模块实现将www.a.com和www.b.com发布出去

  访问www.a.com		显示图书管理系统
  访问www.b.com		显示tomcat首页

实验环境：
	客户端：192.168.19.114
	Nginx：192.168.19.156
	Tomcat：192.168.19.157

6、修改nginx配置文件
[root@localhost ~]# cd /usr/local/nginx/conf/
[root@localhost conf]# vim nginx.conf

worker_processes  3;
events {
        worker_connections   1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  www.a.com;   //通过基于域名的虚拟主机发布www.a.com
        location / {
            rewrite    ^/$   http://192.168.19.157:8080/book; //通过url重写模块实现将访问www.a.com的请求重定向为http://...:8080/book
        }
        }

    server {
        listen       80;
        server_name  www.b.com;   //通过基于域名的虚拟主机发布www.b.com
        location / {
             rewrite    ^/$   http://192.168.19.157:8080;  //通过url重写模块实现将访问www.b.com的请求重定向为http://...:8080
        }
        }
}

 7、重启nginx
	[root@localhost ~]# /etc/init.d/nginx restart
 8、修改客户端的host文件
	vim /etc/hosts 添加192.168.19.156   www.a.com  192.168.19.156   www.b.com
 9、客户端测试
	浏览器输入两个网站域名，分别得到图书管理系统和tomcat首页



================================================================


17、nginx负载均衡的高可用
	lvs :   keepalived  

	项目名称：
		nginx负载均衡的高可用
	项目环境：
		os:
		keepalived:
		nginx:
		apache:
	ip地址划分：
		nginx1：		245
		nginx2:		246
		client:		248
		rs1:		241
		rs2:		242

实 现：
1、部署nginx2将该安装脚本存放的目录拷贝到/usr/src

[root@host ~]# cd /usr/src/
[root@host src]# rz
[root@host src]# chmod 755 ./*
[root@host src]# ./nginx_install.sh

2、执行安装脚本并运行nginx 2服务
[root@host src]# ./nginx_install.sh
[root@host nginx]# sbin/nginx
[root@host nginx]# lsof -i:80

3、配置两台nginx的负载均衡--使用rr算法，rs1的页面是RS1，
	rs2的页面RS2；注意两台nginx的配置文件相同！！！

[root@host nginx]# vim conf/nginx.conf
[root@host nginx]# /etc/init.d/nginx restart

worker_processes  3;
events {
        worker_connections   1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  www.a.com;
        location / {
                proxy_pass      http://www;
        }
        }
        upstream www {
        server  192.168.19.114;
        server  192.168.19.155;
}
}

4、测试刚两台的nginx服务器的分发功能
[root@host ~]# elinks http://192.168.19.156 --dump
   17-05-30 12:29:08
[root@host ~]# elinks http://192.168.19.156 --dump
   ### RS2 test ###
[root@host ~]# elinks http://192.168.19.156 --dump
   17-05-30 12:29:14
[root@host ~]# elinks http://192.168.19.156 --dump
   ### RS2 test ###
[root@host ~]# elinks http://192.168.19.157 --dump
   17-05-30 12:29:29
[root@host ~]# elinks http://192.168.19.157 --dump
   ### RS2 test ###
[root@host ~]# elinks http://192.168.19.157 --dump
   17-05-30 12:29:34
[root@host ~]# elinks http://192.168.19.157 --dump
   ### RS2 test ###

5、测试”nginx_pid.sh”脚本：nginx 1（192.168.19.156）
宕机能不能被拉起来，nginx2运行时，客户端可以正常访问：
[root@localhost html]# /etc/init.d/nginx stop
nginx stop				 [ OK ]
[root@localhost html]# lsof -i:80
[root@localhost src]# rz     //在nginx1 156本机上测试脚本
[root@localhost src]# ls
 nginx_pid.sh
[root@localhost src]# chmod 755 nginx_pid.sh
[root@localhost src]# ./nginx_pid.sh
nginx stop				 [ Fail ]
nginx start				 [ OK ]
从上面结果可以看到，脚本是好使的，可以拉起nginx 1


6、部署keepalieved，拷贝整理好的配置文件，将nginx_pid.sh拷贝到指定位置

nginx 1服务器上的部署

[root@localhost src]# rz

[root@localhost src]# chmod 701 ./*
[root@localhost src]# ls
keepalived.conf    keep_install.sh    debug     nginx_pid.sh
nginx-1.5.1        nginx_upstream_hash-0.3.1
[root@localhost src]# ./keep_install.sh
[root@localhost src]# vim /etc/keepalived/keepalived.conf
[root@localhost src]# /etc/init.d/keepalived restart
[root@host src]# cp nginx_pid.sh /etc/keepalived/

! Configuration File for keepalived
global_defs {
#Vrrp Router
        router_id       nginx 1
}

vrrp_script check_nginx {
        script  /etc/keepalived/nginx_pid.sh
        interval 2
        fail 1
}
vrrp_instance apache {
        state MASTER
        interface eth0
        virtual_router_id 51
        priority 100
        advert_int 1
        authentication {
                auth_type PASS
                auth_pass 1111
        }
        virtual_ipaddress {
                192.168.19.150
        }

track_script {
                check_nginx
}
}


nginx 2服务器上的部署

[root@localhost src]# rz

[root@localhost src]# chmod 701 ./*
[root@localhost src]# ls
keepalived.conf    keep_install.sh    debug     nginx_pid.sh
nginx-1.5.1        nginx_upstream_hash-0.3.1
[root@localhost src]# ./keep_install.sh

[root@localhost src]# vim /etc/keepalived/keepalived.conf
[root@localhost src]# /etc/init.d/keepalived restart
[root@host src]# cp nginx_pid.sh /etc/keepalived/

! Configuration File for keepalived
global_defs {
#Vrrp Router
        router_id       nginx 2
}
vrrp_script check_nginx {
        script  /etc/keepalived/nginx_pid.sh
        interval 2
        fail 1
}
vrrp_instance apache {
        state BACKUP
        interface eth0
        virtual_router_id 51
        priority 90
        advert_int 1
        authentication {
                auth_type PASS
                auth_pass 1111
        }
        virtual_ipaddress {
                192.168.19.150
        }

track_script {
                check_nginx
}
}

7、测试---nginx 1死后，keepalived如果救不活，那么keepalived自杀，然后让出VIP。整个过程对用户来说是透明的。
模拟nginx 1宕机
[root@localhost src]# watch -n1 "killall nginx"
[root@localhost src]# /etc/init.d/keepalived status
keepalived 已停

nginx 1 宕机后，nginx 2接管VIP 继续服务

8、客户端测试
[root@host ~]# elinks http://192.168.19.150 --dump
   17-05-30 12:29:08
[root@host ~]# elinks http://192.168.19.150 --dump
   ### RS2 test ###
[root@host ~]# elinks http://192.168.19.150 --dump
   17-05-30 12:29:14
[root@host ~]# elinks http://192.168.19.150 --dump
   ### RS2 test ###


 脚本思路：
    如果nginx死了，尝试重启nginx，如果能够重启nginx成功--这台机器继续担当master角色；否则，keepalived自杀，从而让出VIP。
