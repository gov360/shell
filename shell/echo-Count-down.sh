#!/bin/env bash 
# Author: xiaoxiao
# Created Time: 2018/11/12 14:45
# Script Description: 
echo -n "倒计时: "
for i in $(seq 9 -1 0)
  do 
    echo -n -e "\b$i"
    sleep 1
done
echo 
