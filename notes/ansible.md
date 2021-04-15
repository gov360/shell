# ansible 常用指令
* 列出受管理的主机
```
ansible all --list-hosts
ansible webservers --list-hosts  
```
* 使用ping模块测试机器活动状态
```
ansible all -m ping
```
* 列出已有的可用模块
```
ansible-doc -l
ansible-doc -l | wc -l
```
* 使用copy模块和查看具体用法
```
ansible all -m copy -a 'src=dvd.repo dest=/etc/yum.repos.d owner=root group=root mode=0644' -b
ansible-doc copy
```
* 对某台机器使用设置模块以及应用剧本文件
```
ansible vm2 -m setup
ansible-playbook myplaybook.yml
```
* 使用logger命令进行远程日志记录以及在中央日志服务器上的确认
```
ansible lamp -m command -a 'logger hurray it works'
ansible logservers -m command -a "grep 'hurray it works$' /var/log/messages" -b  
```
* 对剧本进行语法检查
```
ansible-playbook --syntax-check myplaybook.yml
```
* 测试剧本，不进行实际操作
```
ansible-playbook --check myplaybook.yml
```
* 逐步运行剧本(在某些情况下很有用)
```
ansible-playbook --step myplaybook.yml
```
* 使Ansible剧本可执行,将以下内容添加到文件顶部
```
#!/bin/ansible-playbook  
```  
[参考链接](https://www.redhat.com/zh/blog/system-administrators-guide-getting-started-ansible-fast "官方指南参考")
