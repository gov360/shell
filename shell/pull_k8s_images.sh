#!/bin/env bash
# Author: xiaoxiao
# Created Time: 2018/11/20 14:35
# Script Description: pull k8s images 
systemctl stop firewalld
systemctl disable firewalld
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
setenforce 0
swapoff -a
sed -i 's/.*swap.*/#&/' /etc/fstab
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -P /etc/yum.repos.d/
yum list docker-ce.x86_64  --showduplicates |sort -r
yum install docker-ce-18.06.1.ce -y
systemctl daemon-reload
systemctl enable docker
systemctl start docker
V=$(kubeadm config images list |grep ^k8s|awk -F : '{ print $NF }'|sed "s/v//")
for V in 'kube_version'; do
  if [ $V == "${kube_version[@]}" ]; then
kube_version=$V
done
images=(kube-proxy kube-scheduler kube-controller-manager
kube-apiserver kubernetes-dashboard-amd64:v1.10.0 
heapster-amd64:v1.5.4 heapster-grafana-amd64:v5.0.4 heapster-influxdb-amd64:v1.5.2 etcd coredns  pause )
for imageName in "${images[@]}"; do
docker pull anjia0532/google-containers."$imageName"
docker tag anjia0532/google-containers."$imageName" k8s.gcr.io/"$imageName"
docker rmi anjia0532/google-containers."$imageName"
done
