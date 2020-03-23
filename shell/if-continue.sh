#!/bin/env bash 
# Author: xiaoxiao
# Created Time: 2018/11/12 14:26
# Script Description: 
for ((i=1;i<10;i++))
  do
    if [ $i -eq  5 ]
      then  continue
    else 
      echo "$i"
    fi    
done
