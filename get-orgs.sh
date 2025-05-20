#!/bin/bash

ENTERPRISE_SLUG=$1

get_orgs_query() {
    echo "
  		query(\$endCursor: String) {
				enterprise(slug: \"$ENTERPRISE_SLUG\") {
  		    organizations(first: 100, after:\$endCursor) {
  		      nodes { login }
  		      pageInfo {
  		        hasNextPage
  		        endCursor
  		      }
  		    }
  		  }
  		}
    "
}

DATA=$(gh api graphql --paginate -F query="$(get_orgs_query)" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2023-11-28")
echo "$DATA" | jq -r '.data.enterprise.organizations.nodes[] | .login' > data/orgs.tmp
