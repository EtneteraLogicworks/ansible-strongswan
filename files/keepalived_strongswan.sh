#!/bin/bash

TYPE=$1
NAME=$2
STATE=$3

echo "${TYPE} ${NAME} is in ${STATE} state" > "/var/run/keepalived.${TYPE}.${NAME}.state"

case $STATE in
        "MASTER") systemctl start strongswan-swanctl.service
                  ;;
        "BACKUP") systemctl stop strongswan-swanctl.service
                  ;;
        "STOP") systemctl stop strongswan-swanctl.service
                  ;;
        "FAULT")  systemctl stop strongswan-swanctl.service
                  ;;
        *)        /sbin/logger "ipsec unknown state"
                  exit 1
                  ;;
esac

exit 0
