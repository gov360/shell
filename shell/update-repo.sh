#!/bin/env bash
# Author: xiaoxiao
# Created Time: 2018/10/26 14:32
# Script Description: update repo

##############################################
# yum repo
##############################################
info_echo "配置yum源......"
if [ ! -f kubernetes+docker.repo ]; then
cat> /etc/yum.repos.d/kubernetes+docker.repo <<'EOF'
[kubernetes]
name=kubernetes repo
baseurl=https://mirrors.aliyun.com/centos/$basearch/
gpgcheck=0
enabled=1
  
[docker]
name=docker Repository 
baseurl=http://yum.dockerproject.org/repo/main/centos/7/$basearch
enabled=1
gpgcheck=0
EOF
fi
