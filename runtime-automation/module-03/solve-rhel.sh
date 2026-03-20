#!/bin/sh
echo "Module-03 solve: Investigating the mystery" >> /tmp/progress.log

# Commands the participant should run to understand the situation
ps aux | grep -i business
BUSINESS_PID=$(pgrep -f business-monitor.sh)
echo "Business monitor PID: $BUSINESS_PID"
ls -l /proc/$BUSINESS_PID/fd/

echo "Module-03 solve complete - discovered deleted-but-open file!" >> /tmp/progress.log
