#!/bin/bash

# Get the breakdown data for the usage in the enterprise
DATA=$(gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /enterprises/$1/copilot/usage)

# Adding Headers to the CSV file
echo "Day,Language,Editor,Suggestions,Acceptances,Lines Suggested,Lines Accepted,Active Users" >> $2

# The breakdown part of the data is extracted and converted to CSV, and saved to a file
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
  ] | @csv' >> $2

echo "Break-down Metrics for enterprise:$1 is saved in $2"