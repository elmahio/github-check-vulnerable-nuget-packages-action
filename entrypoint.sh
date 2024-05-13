#!/bin/sh -l

wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh

set -e # This will cause the script to exit on the first error
OUTPUT=$(dotnet list package --vulnerable)
echo "$OUTPUT"
if echo "$OUTPUT" | grep -q 'no vulnerable packages'; then
  echo "No vulnerable packages found"
else
  if echo "$OUTPUT" | grep -q 'vulnerable'; then
    echo "Vulnerable packages found"
    exit 1
  fi
fi