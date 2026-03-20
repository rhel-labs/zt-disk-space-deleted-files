#!/bin/sh
echo "Module-05 validation: Verifying process is stopped" >> /tmp/progress.log

# Verify the business-monitor process is NOT running
if pgrep -f business-monitor.sh > /dev/null; then
    echo "FAIL: Business monitor process should be stopped"
    exit 1
fi

# Verify there are no deleted files with lsof
if lsof +L1 /var/log 2>/dev/null | grep -q business-monitor; then
    echo "FAIL: Deleted file should be cleaned up"
    exit 1
fi

echo "PASS: Process stopped and space reclaimed" >> /tmp/progress.log
exit 0
