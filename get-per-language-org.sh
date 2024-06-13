#!/bin/bash

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
    "ORG_NAME_PLACEHOLDER",
    .language,
    .editor,
    .suggestions_count,
    .acceptances_count,
    .lines_suggested,
    .lines_accepted,
    .active_users
  ] | @csv' >> $2

## Replace ORG_NAME_PLACEHOLDER with the actual organization name
sed -i "s/ORG_NAME_PLACEHOLDER/$1/g" $2

echo "Breakdown data saved to $2"