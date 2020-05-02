#!/bin/env bash
#Author: xiaoxiao
#Created time: 2018/11/5 19:45
#Script Description: Nginx日志切割脚本
# set file path
NGINX_ACCESS_LOG=/opt/logs/nginx/access/log.pipe
NGINX_ERROR_LOG=/opt/logs/nginx/error/log
NGINX_STATIS_LOG=/opt/logs/nginx/statis/log
# rename log
mv $NGINX_ACCESS_LOG $NGINX_ACCESS_LOG.`date -d yesterday +%Y%m%d`
mv $NGINX_ERROR_LOG $NGINX_ERROR_LOG.`date -d yesterday +%Y%m%d`
mv $NGINX_STATIS_LOG $NGINX_STATIS_LOG.`date -d yesterday +%Y%m%d`
touch $NGINX_ACCESS_LOG
touch $NGINX_STATIS_LOG
touch  $NGINX_ERROR_LOG
# restart nginx
/etc/init.d/nginx  reload
