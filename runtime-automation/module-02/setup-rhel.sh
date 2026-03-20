#!/bin/sh
echo "Starting module-02: Finding the Large File" >> /tmp/progress.log

# Start the business-monitor script in the background as the rhel user
su - rhel -c "nohup /home/rhel/business-monitor.sh > /dev/null 2>&1 &"

# Give it a moment to start and create the log file
sleep 2

# Let it run for a bit to build up a substantial log file
# This simulates a runaway log that's been growing over time
sleep 5

echo "Business monitor started, log file growing..." >> /tmp/progress.log

# Verify the file was created
if [ -f /var/log/super-business/business-monitor.log ]; then
    FILE_SIZE=$(du -sh /var/log/super-business/business-monitor.log | cut -f1)
    echo "Log file created: $FILE_SIZE" >> /tmp/progress.log
fi
