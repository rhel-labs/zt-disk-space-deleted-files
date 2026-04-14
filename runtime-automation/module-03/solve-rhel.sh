#!/bin/sh
echo "Module-03 solve: Investigating the mystery" >> /tmp/progress.log

# Commands the participant should run to understand the situation
systemctl status business-monitor.service
BUSINESS_PID=$(systemctl show -p MainPID --value business-monitor.service)
echo "Business monitor PID: $BUSINESS_PID" >> /tmp/progress.log
pgrep -f business-monitor.sh
ls -l /proc/$BUSINESS_PID/fd/

echo "Module-03 solve complete - discovered deleted-but-open file!" >> /tmp/progress.log
