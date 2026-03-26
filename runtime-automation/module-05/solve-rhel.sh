#!/bin/sh
echo "Module-05 solve: Restarting the service and freeing space" >> /tmp/progress.log

# Commands the participant should run
df -h / | tail -1
systemctl restart business-monitor.service
sleep 1
systemctl status business-monitor.service
df -h / | tail -1
lsof +L1 /var/log 2>/dev/null

echo "Module-05 solve complete" >> /tmp/progress.log
