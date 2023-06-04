#!/bin/bash

##Simple script to monitor Zookeeper /root utilization due bad best practice where Zookeeper is sharing same mount point as the system

##Variables

ROOT_UTIL=$(df -hPT / | awk '{print $6}' |grep -Eo [0-9]+)
Z_PATH='/var/lib/zookeeper/version-2'
ZOO_cleanup=$(/opt/cloudera/parcels/CDH-6.3.4-1.cdh6.3.4.p4368.7037554/bin/zookeeper-server-cleanup -n 3)

##Script body

if [[ ROOT_UTIL -gt 95 ]]; then
    logger "Root usage $ROOT_UTIL% - running Zookeeper cleanup, logs saved into $Z_PATH"
    cd $Z_PATH ; ls -latr log.* |awk '{print $NF}' |head -n -1 |xargs tar -czf zookeeper_log_dump-`date '+%Y-%m-%d-%H-%M'`.gz
    $ZOO_cleanup
    else logger "Root utilization okay"
fi
