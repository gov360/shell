# RocketMQ单机版安装
```
tar xvf jdk-8u172-linux-x64.tar.gz -C /usr/local/
unzip rocketmq-all-4.7.0-bin-release.zip 
mv rocketmq-all-4.7.0-bin-release /usr/local/
cd /usr/local/
ln -s jdk1.8.0_172/ /usr/java
ln -s /usr/local/jdk1.8.0_172/ java
echo PATH=$PATH:/usr/local/java/bin >> ~/.bash_profile 
. ~/.bash_profile 
java 
ln -s rocketmq-all-4.7.0-bin-release/ rocketmq
cd rocketmq/bin/
vi runserver.sh 
vi runbroker.sh 
vi ../conf/broker.conf 
cd /usr/bin/
ln -s /usr/local/rocketmq/bin/mqshutdown mqshutdown
ln -s /usr/local/rocketmq/bin/mqnamesrv mqnamesrv
ln -s /usr/local/rocketmq/bin/mqbroker mqbroker
vi /usr/local/rocketmq/bin/start_namesrv.sh
vi /usr/local/rocketmq/bin/stop_namesrv.sh
vi /usr/local/rocketmq/bin/stop_broker.sh
vi /usr/local/rocketmq/bin/start_rocketmq-console.sh
ll /usr/local/rocketmq/bin/
chmod 755 /usr/local/rocketmq/bin/*
ll /usr/local/rocketmq/bin/
cd /usr/bin/
ln -s /usr/local/rocketmq/bin/start_namesrv.sh mqsrvstart
ln -s /usr/local/rocketmq/bin/start_broker.sh mqbrostart
ln -s /usr/local/rocketmq/bin/stop_namesrv.sh mqsrvstop
ln -s /usr/local/rocketmq/bin/stop_broker.sh mqbrostop
ln -s /usr/local/rocketmq/bin/start_rocketmq-console.sh mqconstart  
cd
mqsrvstart 
mqbrostart 
jps
yum install git
git clone https://github.com/apache/rocketmq-externals.git
yum provides mvn
yum install maven
cd  rocketmq-externals/rocketmq-console/
mvn clean package -Dmaven.test.skip=true
cd target/
ls
nohup java -jar rocketmq-console-ng-1.0.1.jar --server.port=8080 --rocketmq.config.namesrvAddr=127.0.0.1:9876 &
jps

```
[参考链接](https://www.jianshu.com/p/9344fe6cfc3c "非官方文档")