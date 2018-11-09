#!/bin/env bash
# Author: xiaoxiao
# Created Time: 2018/10/19 20:45
# Script Description: if root
if [ $USER != 'root' ]
   then
       echo "hey admin"
else
       echo "hey guest"
fi
