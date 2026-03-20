#!/bin/sh
echo "Module-04 solve: Using lsof to find deleted files" >> /tmp/progress.log

# Commands the participant should run
lsof | grep deleted
lsof +L1 /var/log
BUSINESS_PID=$(pgrep -f business-monitor.sh)
ps -p $BUSINESS_PID -f

echo "Module-04 solve complete" >> /tmp/progress.log
