#!/bin/bash
LOGFILE="/var/log/keepalived_script.log"
echo "Script executed at $(date)" >> $LOGFILE
if [[ $(/usr/bin/curl -s http://localhost:8008/health | grep -c '"role": "primary"') -eq 1 ]]; then
exit 0
else