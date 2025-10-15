#!/bin/bash

# Prompt user for assignment name
echo "Enter the assignment name:"
read assignment_name

# Prompt user for days remaining
echo "Enter the number of days remaining to submit:"
read days_remaining

# Update the config.env file with new values
config_file="./config/config.env"

# Create or update the config file
cat > "$config_file" << EOF
# This is the config file
ASSIGNMENT="$assignment_name"
DAYS_REMAINING=$days_remaining
EOF

echo "Configuration updated successfully!"
echo "Assignment: $assignment_name"
echo "Days remaining: $days_remaining"
echo ""
echo "Running reminder check..."
echo ""

# Run the reminder script
cd app && ./reminder.sh
