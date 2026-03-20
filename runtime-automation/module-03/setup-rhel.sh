#!/bin/sh
echo "Starting module-03: The Mystery - Space Not Freed" >> /tmp/progress.log

# Let the deleted file continue to grow
sleep 2

echo "Deleted file continuing to grow via open filehandle..." >> /tmp/progress.log
