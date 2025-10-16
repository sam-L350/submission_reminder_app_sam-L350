#!/bin/bash

# Prompt user for their name and create directory
echo "Enter your name:"
read username

# Create main directory with username of the user
main_dir="submission_reminder_${username}"
mkdir -p "$main_dir"

# Create subdirectories
mkdir -p "$main_dir/app"
mkdir -p "$main_dir/modules"
mkdir -p "$main_dir/assets"
mkdir -p "$main_dir/config"

# Create reminder.sh in app directory
cat > "$main_dir/app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# Create functions.sh in modules directory
cat > "$main_dir/modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# Create submissions.txt in assets directory
cat > "$main_dir/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
EOF

# Create config.env in config directory
cat > "$main_dir/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Make reminder.sh executable
chmod +x "$main_dir/app/reminder.sh"
chmod +x "$main_dir/modules/functions.sh"

echo "Directory structure created successfully!"
echo "Created: $main_dir"
echo ""
echo "To test the application, run:"
echo "cd $main_dir/app && ./reminder.sh"
