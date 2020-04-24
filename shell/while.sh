#!/bin/env bash

PID=`pidof fcitx`
while [ $PID > 1000 ];do
  echo "你的PID是$PID times"
  PID=$(($PID -1))
done