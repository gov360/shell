#!/bin/env bash
# *lang=utf-8*
# 解决fcitx在使用过程中突然消耗大量资源的问题。
#PROCESS="fcitx"
PID=`pidof fcitx`
#while [ ! $PID ]; do
#       PID=`pgrep $PROCESS | head -n 1`
#done

#while [[ 1 ]]; do
        CPU=`top -b -p $PID -n 1 | tail -n 1 | awk '{print $9}'`
        if [ $CPU > 10.0 ]; then
                kill $PID
                PID=""
                #while [ ! $PID ]; do
                #        sleep 1
                #        PID=`pidof fcitx`
                #done
        else
                echo normal
        fi
        sleep 4
done