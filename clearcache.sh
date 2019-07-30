#!/usr/bin/env bash

#从内存中取出数据放到硬盘中
sync
#表示清除pagecache和slab分配器中的缓存对象。
echo 3 > /proc/sys/vm/drop_caches
echo 0 > /proc/sys/vm/drop_caches

# socket的最大连接数的修改
# echo 50000 > /proc/sys/net/core/somaxconn
# 加快系统的tcp回收
# echo  1 > /proc/sys/net/ipv4/tcp_tw_recycle
# 允许空的tcp回收利用
# echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse

