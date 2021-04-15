#!/bin/env bash 
# Author: xiaoxiao
# Created Time: 2018/11/12 14:45
# Script Description: 
for i in $(seq 1 9);
  do
    echo "$i"
    if [[ $i -eq 5 ]] 
      then  break
    fi    
done
