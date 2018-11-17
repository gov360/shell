#!/bin/env bash
# Author: xiaoxiao
# Created Time: 2018/11/20 14:35
# Script Description: pull k8s images 
images=(kube-proxy:v1.12.1 kube-scheduler:v1.12.1 kube-controller-manager:v1.12.1
kube-apiserver:v1.12.1 kubernetes-dashboard-amd64:v1.10.0 
heapster-amd64:v1.5.4 heapster-grafana-amd64:v5.0.4 heapster-influxdb-amd64:v1.5.2 etcd:3.2.24 coredns:1.2.2 pause:3.1 )
for imageName in ${images[@]} ; do
docker pull anjia0532/google-containers.$imageName
docker tag anjia0532/google-containers.$imageName k8s.gcr.io/$imageName
docker rmi anjia0532/google-containers.$imageName
done
