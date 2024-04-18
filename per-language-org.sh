#!/bin/bash

# Define the path to the output file
OUTPUT_FILE="org-per-language-result.csv"

# Get the breakdown data for the usage in the organization
DATA=$(gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /orgs/$1/copilot/usage)

# Convert the retrieved data to CSV using jq and save it to a file
echo "$DATA" | jq -r '
  .[] | 
  .day as $day |
  .breakdown[] |
  [
    $day,
    .language,
    .editor,
    .suggestions_count,
    .acceptances_count,
    .lines_suggested,
    .lines_accepted,
    .active_users
  ] | @csv' > "$OUTPUT_FILE"

echo "Breakdown data saved to $OUTPUT_FILE"