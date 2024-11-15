#!/bin/bash
set -e # Exit on the first error

# Enable logging
LOG_FILE=/tmp/action-log.txt
exec > >(tee -a "$LOG_FILE") 2>&1

# Ensure the dotnet command is available in PATH
export PATH="$PATH:/usr/share/dotnet"

# Read the input argument (newline-separated list of projects)
projects=$1

# Determine which projects to check
if [[ -z "$projects" ]]; then
  echo "No projects specified. Searching current directory for project files..."
  projects=$(find . -name '*.csproj' -o -name '*.sln')
fi

# Split the projects into an array using a while loop for compatibility
project_files=()
while IFS= read -r line; do
  # Skip empty lines
  if [[ -n "$line" ]]; then
    project_files+=("$line")
  fi
done <<< "$projects"

# Debugging: Print resolved project paths
echo "Resolved project paths:"
for project in "${project_files[@]}"; do
  echo "$project"
done

# Initialize a flag to track if vulnerabilities are found
vulnerabilities_found=0

# Process each project
for project in "${project_files[@]}"; do
  # Remove any surrounding quotes from the project path
  project=$(echo "$project" | tr -d "'")
  echo "Checking vulnerabilities for: $project"
  
  # Run the vulnerability check
  OUTPUT=$(dotnet list "$project" package --vulnerable || echo "Error processing $project")
  
  echo "$OUTPUT"
  
  # Check if the output indicates vulnerabilities
  if echo "$OUTPUT" | grep -q 'no vulnerable packages'; then
    echo "No vulnerable packages found in $project"
  else
    if echo "$OUTPUT" | grep -q 'vulnerable'; then
      echo "Vulnerable packages found in $project"
      vulnerabilities_found=1
    fi
  fi
done


# Exit with an error if any vulnerabilities were found
if [[ $vulnerabilities_found -eq 1 ]]; then
  echo "One or more projects contain vulnerable packages. Please address these issues."
  exit 1
else
  echo "All projects are free of vulnerable packages."
fi
