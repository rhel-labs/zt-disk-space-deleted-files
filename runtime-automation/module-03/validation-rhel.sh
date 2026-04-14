#!/bin/sh
echo "Module-03 validation: Checking deleted file scenario" >> /tmp/progress.log

# Verify the business-monitor process is still running
if ! pgrep -f business-monitor.sh > /dev/null; then
    echo "FAIL: Business monitor process is not running" >> /tmp/progress.log
    exit 1
fi

# Verify the log file is deleted from directory
if [ -f /var/log/super-business/business-monitor.log ]; then
    echo "FAIL: Log file should be deleted" >> /tmp/progress.log
    exit 1
fi

# Verify the process still has the file open (check fd directory)
BUSINESS_PID=$(pgrep -f business-monitor.sh)
if ! ls -l /proc/$BUSINESS_PID/fd/ 2>/dev/null | grep -q deleted; then
    echo "FAIL: Process should have deleted file open" >> /tmp/progress.log
    exit 1
fi

echo "PASS: File is deleted but process still has it open" >> /tmp/progress.log
exit 0
