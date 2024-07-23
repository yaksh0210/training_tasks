#!/bin/bash

# Script Initialization

SCRIPT_NAME="System Monitoring Script"
SCRIPT_VERSION="1.0"
CONFIG_FILE="monitoring_config.conf"

# Load configuration 

if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
else
  echo "Error: Configuration file $CONFIG_FILE not found."
  exit 1
fi

# Validate required commands 

REQUIRED_COMMANDS=("vmstat" "free" "df" "netstat" "ps" "grep" "awk" "mail")

for COMMAND in "${REQUIRED_COMMANDS[@]}"; do
  if ! command -v "$COMMAND" &> /dev/null; then
    echo "Error: $COMMAND is not installed or not available."
    exit 1
  fi
done

# System Metrics Collection

CPU_USAGE=$(vmstat | awk '$12 ~ /[0-9.]+/ { print 100 - $12 }')
MEMORY_USAGE=$(free -m | awk '/Mem:/ { print $3/$2 * 100 }')
DISK_SPACE=$(df -h --output=pcent / | awk '{ print $1 }')
NETWORK_STATS=$(netstat -an | awk '/tcp/ { print $6 }')

# Capture process information

TOP_PROCESSES=$(ps -eo pcpu,pmem,cmd --sort=-pcpu | head -n 10)

# Log Analysis

LOG_FILE="/var/log/syslog"
CRITICAL_EVENTS=$(cat "$LOG_FILE" | tail -n 10)
LOG_SUMMARY=$(grep -i "crit|error" "$LOG_FILE" | awk '{ print $1 " " $2 " " $3 }')

# Health Checks

ESSENTIAL_SERVICES=("Apache" "MySQL")
for SERVICE in "${ESSENTIAL_SERVICES[@]}"; do
  if ! systemctl is-active "$SERVICE" &> /dev/null; then
    echo "Error: $SERVICE is not running."
  fi
done

# Alerting Mechanism

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
  echo "CPU usage is critical: $CPU_USAGE%"
  mail -s "CPU Usage Critical" "$SYSADMIN_EMAIL" <<< "CPU usage is critical: $CPU_USAGE%"
fi

if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
  echo "Memory usage is critical: $MEMORY_USAGE%"
  mail -s "Memory Usage Critical" "$SYSADMIN_EMAIL" <<< "Memory usage is critical: $MEMORY_USAGE%"
fi

# Report Generation

REPORT_FILE="system_report.txt"
echo "System Report: $(date)" > "$REPORT_FILE"

cat >> "$REPORT_FILE" << EOF
System Metrics:
CPU Usage: $CPU_USAGE%
Memory Usage: $MEMORY_USAGE%
Disk Space: $DISK_SPACE%
Network Stats: $NETWORK_STATS

Top Processes:
$TOP_PROCESSES

Log Analysis:
Critical Events:
$CRITICAL_EVENTS
Log Summary:
$LOG_SUMMARY

Health Checks:
$(for SERVICE in "${ESSENTIAL_SERVICES[@]}"; do
  if systemctl is-active "$SERVICE" &> /dev/null; then
    echo "$SERVICE is running."
  else
    echo "$SERVICE is not running."
  fi
done)
EOF


# Automation and Scheduling

if [ "$INTERACTIVE_MODE" = "true" ]; then
  echo "Interactive mode enabled."
  while true; do
    echo "Enter a command ( metrics, logs, health, report, exit ):"
    read COMMAND
    case $COMMAND in
      metrics)
        echo "System Metrics:"
        echo "CPU Usage: $CPU_USAGE%"
        echo "Memory Usage: $MEMORY_USAGE%"
        echo "Disk Space: $DISK_SPACE%"
        echo "Network Stats: $NETWORK_STATS"
        ;;
      logs)
        echo "Log Analysis:"
        echo "Critical Events:"
        echo "$CRITICAL_EVENTS"
        echo "Log Summary:"
        echo "$LOG_SUMMARY"
        ;;
      health)
        echo "Health Checks:"
        for SERVICE in "${ESSENTIAL_SERVICES[@]}"; do
          if systemctl is-active "$SERVICE" &> /dev/null; then
            echo "$SERVICE is running."
          else
            echo "$SERVICE is not running."
          fi
done
        ;;
      report)
        echo "Generating report..."
        cat "$REPORT_FILE"
        ;;
      exit)
        exit 0
        ;;
      *)
        echo "Invalid command. Try again."
        ;;
    esac
  done
else
  echo "Non-interactive mode enabled."

  # Schedule the script to run periodically via cron

  crontab -l | { cat; echo "*/15 * * * * $0"; } | crontab -
fi
