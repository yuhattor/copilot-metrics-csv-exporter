#!/bin/bash

# Define the file paths
org_total="data/organization-total.csv"
ent_total="data/enterprise-total.csv"
org_per_lang="data/organization-per-language-result.csv"
ent_per_lang="data/enterprise-per-language-result.csv"

# Get the breakdown data for the usage in the enterprise
sh get-per-language-ent.sh $1 $ent_per_lang
sh get-total-ent.sh $1 $ent_total

# Create list of organizations
sh get-orgs.sh $1

# loop for each line of "orgs.tmp.txt" and pass as the argument
while read org; do
  # Get the breakdown data for the usage in the organization
  sh get-per-language-org.sh $org $org_per_lang
  sh get-total-org.sh $org $org_total
done < data/orgs.tmp

# Remove duplicates
for file in $org_total\
            $ent_total\
            $org_per_lang\
            $ent_per_l; do   
  awk -i inplace '!seen[$0]++' "$file"
done