#!/bin/bash

# Get the breakdown data for the usage in the enterprise
DATA=$(gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /enterprises/$1/copilot/usage)

# Adding Headers to the CSV file
echo "Day,Total Suggestions Count,Total Acceptances Count,Total Lines Suggested,Total Lines Accepted,Total Active Users" >> "$2"
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
  ] | @csv' >> "$2"

echo "Aggregated Metrics for enterprise:$1 is saved in $2"