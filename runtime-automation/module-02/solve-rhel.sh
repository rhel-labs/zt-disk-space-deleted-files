#!/bin/sh
echo "Module-02 solve: Finding and deleting the large file" >> /tmp/progress.log

# Commands the participant should run to find the large file
df -h /
du -sh /* 2>/dev/null | sort -hr | head -10
du -sh /var/log/* 2>/dev/null | sort -hr | head -10
du -sh /var/log/super-business/* 2>/dev/null
ls -lh /var/log/super-business/

# Check what's using the file
lsof /var/log/super-business/business-monitor.log

# Delete the file
rm /var/log/super-business/business-monitor.log

# Verify it's gone
ls -lh /var/log/super-business/

# Check if space was freed (spoiler: it wasn't!)
df -h /

echo "Module-02 solve complete - file deleted but space not freed!" >> /tmp/progress.log
