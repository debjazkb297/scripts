#!/bin/bash

# URL to check internet connectivity
URL="http://google.com"

# File to store the last online timestamp
TIMESTAMP_FILE="/tmp/last_online.txt"

# Function to check internet connectivity
check_internet() {
    wget -q --spider $URL
    return $?
}

# Check if the system is online
if check_internet; then
    # System is online, update the timestamp
    date +%s > $TIMESTAMP_FILE
else
    # System is offline, check the last online timestamp
    if [ -f $TIMESTAMP_FILE ]; then
        LAST_ONLINE=$(cat $TIMESTAMP_FILE)
        CURRENT_TIME=$(date +%s)
        DIFF=$((CURRENT_TIME - LAST_ONLINE))

        # If offline for more than 50 minutes (3000 seconds)
        if [ $DIFF -gt 3000 ]; then
            # Reboot the system
            sudo reboot
        fi
    else
        # If the timestamp file doesn't exist, create it
        date +%s > $TIMESTAMP_FILE
    fi
fi
