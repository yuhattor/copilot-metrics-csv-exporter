#!/bin/bash

# Define the path to the output file
OUTPUT_FILE="enteprise-total.csv"

# Get the breakdown data for the usage in the enterprise
DATA=$(gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /enterprises/$1/copilot/usage)

# Convert the retrieved data to CSV using jq and save it to a file
echo "$DATA" | jq -r '
  .[] | 
  .day as $day |
  .total_suggestions_count as $total_suggestions_count |
  .total_acceptances_count as $total_acceptances_count |
  .total_lines_suggested as $total_lines_suggested |
  .total_lines_accepted as $total_lines_accepted |
  .total_active_users as $total_active_users |
  [
    $day,
    $total_suggestions_count,
    $total_acceptances_count,
    $total_lines_suggested,
    $total_lines_accepted,
    $total_active_users
  ] | @csv' > "$OUTPUT_FILE"

echo "CSV data saved to $OUTPUT_FILE"