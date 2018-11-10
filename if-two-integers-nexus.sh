#!/bin/env bash
# Author: xiaoxiao
# Created Time: 2018/11/11 11:11
# Script Description: 
if [ $1 -gt $2 ]
  then 
  echo "$1 > $2"
elif [ $1 -eq $2 ]
  then
  echo "$1 = $2"
else
  echo "$1 < $2"
fi
