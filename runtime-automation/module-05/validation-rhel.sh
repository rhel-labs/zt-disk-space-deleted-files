#!/bin/sh
echo "Module-05 validation: Verifying service restarted and space freed" >> /tmp/progress.log

# Verify the business-monitor service IS running (after restart)
if ! systemctl is-active --quiet business-monitor.service; then
    echo "FAIL: Business monitor service should be running after restart"
    exit 1
fi

# Verify there are no deleted files with lsof
if lsof +L1 /var/log 2>/dev/null | grep -q business-monitor; then
    echo "FAIL: Deleted file should be cleaned up (no files with deleted marker)"
    exit 1
fi

echo "PASS: Service restarted and space reclaimed" >> /tmp/progress.log
exit 0
