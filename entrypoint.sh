#!/bin/sh -l
set -e # This will cause the script to exit on the first error
# Ensure the dotnet command is available in PATH
export PATH="$PATH:/usr/share/dotnet"
OUTPUT=$(dotnet list $1 package --vulnerable)
echo "$OUTPUT"
if echo "$OUTPUT" | grep -q 'no vulnerable packages'; then
  echo "No vulnerable packages found"
else
  if echo "$OUTPUT" | grep -q 'vulnerable'; then
    echo "Vulnerable packages found"
    exit 1
  fi
fi