#!/bin/sh
echo "Module-04 validation: Verifying lsof understanding" >> /tmp/progress.log

# Verify the business-monitor process is still running
if ! pgrep -f business-monitor.sh > /dev/null; then
    echo "FAIL: Business monitor process should still be running" >> /tmp/progress.log
    exit 1
fi

# Verify lsof can find the deleted file
if ! lsof 2>/dev/null | grep -q deleted; then
    echo "FAIL: Should be able to find deleted files with lsof" >> /tmp/progress.log
    exit 1
fi

echo "PASS: Deleted file found with lsof" >> /tmp/progress.log
exit 0
