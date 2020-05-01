# redis 集群部署  
* 编译并安装redis
```  
tar xvf redis-5.0.5.tar.gz -C /usr/local/
cd /usr/local/redis-5.0.5/
yum grouplist
yum groupinstall 开发工具
tar xvf redis-5.0.5.tar.gz 
cd redis-5.0.5
make
echo $？
make install
mv redis-5.0.5 /usr/local/
redis-cli -h
cd /usr/local/
ln -s redis-5.0.5/ redis
ls
redis-cli 
cd redis/
```  
* 部署redis实例  
```
mkdir cluster-redis
cd cluster-redis/
mkdir 700{0..8}
yum install tree 
tree
cd 7000
vi redis.conf
redis-server ./redis.conf &
cd ../7001/
vi redis.conf
redis-server ./redis.conf &
cd ../7002/
vi redis.conf
redis-server ./redis.conf &
redis-cli -h
cd /usr/local/redis/cluster-redis/
cd 7003/
vi redis.conf
redis-server ./redis.conf &
cd ../7004/
vi redis.conf
redis-server ./redis.conf &
cd ../7005/
vi redis.conf
redis-server ./redis.conf &
cd ..
ps aux |grep redis
pwd
redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1  
```  
* 链接登录集群
```
redis-cli -c -p 7000
redis-cli --cluster help
```  
* 对数据进行重新分片
```
redis-cli --cluster reshard 127.0.0.1:7000
redis-cli -p 7000 cluster nodes|grep myself
redis-cli --cluster check 127.0.0.1:7000
redis-cli -c -p 7000
redis-cli -p 7000 cluster nodes |grep master
redis-cli --cluster reshard 127.0.0.1:7000 
```  
* 对单个节点进行崩溃测试
```
redis-cli -p 7002 debug segfault
redis-cli -p 7000 cluster nodes |grep master
redis-cli -h
redis-cli -p 7001 cluster nodes
cd 7002/
redis-server ./redis.conf &
redis-cli -p 7001 cluster nodes
```  
* 添加一个新的节点
```
cd ../7006/
cp ../7000/redis.conf  .
vi redis.conf 
cp redis.conf ../7007/
vi ../7007/redis.conf 
less redis.conf 
redis-server ./redis.conf &
cd ../7007/
less redis.conf 
redis-server ./redis.conf &
redis-cli --cluster add-node 127.0.0.1:7006 127.0.0.1:7000
redis-cli -c -p 7006
```  
* 添加从节点(slave)
```
redis-cli --cluster add-node 127.0.0.1:7007 127.0.0.1:7000 --cluster-slave
redis-cli -c -p 7006
```  
* 查看该节点下有多少slave
```
redis-cli -p 7000 cluster nodes |grep slave |grep be6226a936f62409b0e87057cc29cf87d162e894
redis-cli -p 7000 cluster nodes |grep slave
redis-cli -p 7000 cluster nodes |grep master
```  
* 删除从节点
```
redis-cli --cluster del-node 127.0.0.1:7000 f161fbc0d79e7d1afaaecca9c436933c40ce0797
redis-cli -p 7000 cluster nodes |grep master
redis-cli -p 7000 cluster nodes |grep slave |grep be6226a936f62409b0e87057cc29cf87d162e894
redis-cli -p 7000 cluster nodes |grep slave
```  
* 重新加回来刚删除的节点 
```
ps aux |grep redis
cd ../7000/
redis-server ./redis.conf &
ps aux |grep redis
redis-cli -p 7001 cluster nodes 
redis-cli -c -p 7001
ps aux|grep redis
redis-cli --cluster check 127.0.0.1:7001 
redis-cli --cluster check 127.0.0.1:7000
redis-cli -c -p 7000
redis-cli -c -p 7000 cluster nodes|grep slave
redis-cli --cluster help
redis-cli -c -p 7005
```  
[redis集群文档参考](https://redis.io/topics/cluster-tutorial "官方说明")