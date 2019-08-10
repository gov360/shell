


saltstack 安装：
DEPENDENCIES
Salt should run on any Unix-like platform so long as the dependencies are met.

Python 2.6 >= 2.6 <3.0
msgpack-python - High-performance message interchange format
YAML - Python YAML bindings
Jinja2 - parsing Salt States (configurable in the master settings)
MarkupSafe - Implements a XML/HTML/XHTML Markup safe string for Python
apache-libcloud - Python lib for interacting with many of the popular cloud service providers using a unified API
Requests - HTTP library
Tornado - Web framework and asynchronous networking library
futures - Backport of the concurrent.futures package from Python 3.2
Depending on the chosen Salt transport, ZeroMQ or RAET, dependencies vary:

ZeroMQ:

ZeroMQ >= 3.2.0

pyzmq >= 2.2.0 - ZeroMQ Python bindings

PyCrypto - The Python cryptography toolkit

Python版本大于2.6或版本小于3.0：对Python 版本要求

·msgpack-python：SalStack消息交换库

·YAML：SaltStack配置解析定义语法

·Jinja2：SaltStack states配置模板

·MarkupSafe：Python unicode转换库

·apache-libcloud：SaltStack对云架构编排库

·Requests：HTTP Python库

·ZeroMQ：SaltStack消息系统

·pyzmq：ZeroMQ Python库

·PyCrypto：Python密码库

·M2Crypto：Openssl Python包装库



安装 salt ： RHEL / CENTOS / SCIENTIFIC LINUX / AMAZON LINUX / ORACLE LINUX

https://docs.saltstack.com/en/latest/topics/installation/rhel.html


yum方式安装：
配置官方yum源：
```
[saltstack-repo]
name=SaltStack repo for Red Hat Enterprise Linux $releasever
baseurl=https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest
enabled=1
gpgcheck=1
gpgkey=https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/SALTSTACK-GPG-KEY.pub
       https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/base/RPM-GPG-KEY-CentOS-7

master:
	yum install salt-master -y
	chkconfig salt-master on
	service salt-master start
minion:
	yum install salt-minion -y
	chkconfig salt-minion on
	service salt-minion start
```
防火墙：
	
	iptables -I INPUT -m state --state new -m tcp -p tcp --dport 4505 -j ACCEPT
	
	iptables -I INPUT -m state --state new -m tcp -p tcp --dport 4506 -j ACCEPT

publish_port:	4505

ret_port:	4506

####yum install salt-ssh
####yum install salt-syndic
####yum install salt-cloud

salt-2016.11.1：
cb1b8d20bf7b41d323e7675e28cc9114  ./python-crypto-2.6.1-2.el6.x86_64.rpm
6624515076c0a79c80929562e967d7e2  ./python-futures-3.0.3-1.el6.noarch.rpm
6f11fc3bd8a8c382f0585bd41a249487  ./python-jinja2-2.7.3-1.el6.noarch.rpm
7325077903a45660895e410f7569d640  ./python-markupsafe-0.11-10.el6.x86_64.rpm
0af9a56b1b429513edc6f11771c33000  ./python-msgpack-0.4.6-1.el6.x86_64.rpm
5d99881306c77e1f6b3c258907f4f9ca  ./python-tornado-4.2.1-1.el6.x86_64.rpm
ae3689f8a3d3fa00cc10dd808a100cb7  ./python-zmq-14.5.0-2.el6.x86_64.rpm
6b2644fa4202ba3734b8fecf4208284a  ./PyYAML-3.11-1.el6.x86_64.rpm
cbbe530b537b8c7fd7aa23303cfc8f90  ./salt-2016.11.1-1.el6.noarch.rpm
03cc55737ede289afaaccd3490dd26ff  ./salt-master-2016.11.1-1.el6.noarch.rpm
3e22f4ed49edd696884c9af87395d367  ./salt-minion-2016.11.1-1.el6.noarch.rpm
32e413bd27a0ff06c9e36135078e3aab  ./zeromq-4.0.5-4.el6.x86_64.rpm


配置：

1.master:
	[/etc/salt/master]
	interface: 10.1.1.1

	service salt-master restart

2.minion:
	[/etc/salt/minion]
	master: 10.1.1.1
	id: minion-1

	service salt-minion restart



校验安装结果：
	
	salt-key -L	,显示已经或未认证的被控端id，Accepted Keys为已认证清单，Unaccepted Keys为未认证清单

        salt 'minion-1' test.ping
	
	salt-key -D 	,删除所有认证主机id证书
	
	salt-key -d id	,删除单个id
	
	salt-key -A	,接受所有id证书请求
	
	salt-key -a id	,接受单个id证书请求
