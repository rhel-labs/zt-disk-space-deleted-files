#!/bin/bash
USER=rhel

echo "Adding wheel" > /root/post-run.log
usermod -aG wheel rhel

echo "Setup vm rhel" > /tmp/progress.log

chmod 666 /tmp/progress.log

# Create a directory for our scenario
mkdir -p /var/log/super-business
chown rhel:rhel /var/log/super-business

# Create a script that simulates a runaway logging process
cat > /home/rhel/business-monitor.sh << 'EOF'
#!/bin/bash
# Super-Business Critical Business Monitor
# Monitors all the super-businessey things

while true; do
    echo "$(date) - BUSINESS: Monitoring business metrics for super business operations" >> /var/log/super-business/business-monitor.log
    echo "$(date) - BUSINESS: Business productivity is at business levels" >> /var/log/super-business/business-monitor.log
    echo "$(date) - BUSINESS: All business functions operating within business parameters" >> /var/log/super-business/business-monitor.log
    sleep 0.1
done
EOF

chmod +x /home/rhel/business-monitor.sh
chown rhel:rhel /home/rhel/business-monitor.sh

echo "Lab setup complete" >> /tmp/progress.log
