#!/bin/bash

# Define the output file 

OUTPUT_FILE="log_report.txt"

# Functions Of disk_usage , Check Memory and check CPU load
check_log() {
    echo "logs are shown below :-"
    cat /var/log/syslog | tail -n 4
    echo
}

# Write the results to the output file if specified
if [ -n "$OUTPUT_FILE" ]; then
    {
        check_log
    } > "$OUTPUT_FILE" 

    echo "Report saved to $OUTPUT_FILE"
fi
