#!/bin/env bash
# Author: xiaoxiao
# Created Time: 2018/11/20 14:35
# Script Description: pull k8s images 
for V in 'kubeadm config images list |grep ^k8s|awk -F : '{ print $NF }'|sed "s/v//"'; do
  if [ $imageName == ^ ]; then
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
