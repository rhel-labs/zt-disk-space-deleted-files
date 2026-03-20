#!/bin/sh
echo "Module-05 solve: Killing the process and freeing space" >> /tmp/progress.log

# Commands the participant should run
df -h / | tail -1
pgrep -f business-monitor.sh
pkill -f business-monitor.sh
sleep 1
pgrep -f business-monitor.sh
df -h / | tail -1
lsof +L1 /var/log 2>/dev/null

echo "Module-05 solve complete" >> /tmp/progress.log
