#!/bin/bash

SYSLOG_FILE="/var/log/syslog"
AUTH_LOG_FILE="/var/log/auth.log"

check_logs() {
    local file=$1
    local keyword=$2
    echo "Checking $file for '$keyword'..."
    grep "$keyword" "$file" | tail -n 5
}

echo "Starting log check..."
echo "System Log Errors "
check_logs $SYSLOG_FILE "error"

echo "Authentication Failures "
check_logs $AUTH_LOG_FILE "authentication failure"

echo "Log check completed."

