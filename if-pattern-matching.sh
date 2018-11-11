#!/bin/env bash
# Author: xiaoxiao
# Created Time: 2018/11/25 14:36
# Script Description:
for var in ab ac rx bx rvv vt 
  do
    if  [[ "$var" == r* ]] 
        then
          echo "$var"
    fi
done
