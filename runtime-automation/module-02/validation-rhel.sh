#!/bin/sh
echo "Module-02 validation: Checking if file was deleted" >> /tmp/progress.log

# Verify the business-monitor process is still running
if ! pgrep -f business-monitor.sh > /dev/null; then
    echo "FAIL: Business monitor process should still be running"
    exit 1
fi

# Verify the log file has been deleted from the directory
if [ -f /var/log/super-business/business-monitor.log ]; then
    echo "FAIL: Log file should be deleted"
    echo "HINT: Use 'rm /var/log/super-business/business-monitor.log' to delete it"
    exit 1
fi

# Verify the process still has the deleted file open
BUSINESS_PID=$(pgrep -f business-monitor.sh)
if ! ls -l /proc/$BUSINESS_PID/fd/ 2>/dev/null | grep -q deleted; then
    echo "FAIL: Process should still have the deleted file open"
    exit 1
fi

echo "PASS: File deleted but process still has it open (mystery!)" >> /tmp/progress.log
exit 0
