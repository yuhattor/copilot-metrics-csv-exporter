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

DATA=$(gh api graphql --paginate -f query="$(get_orgs_query)")
echo "$DATA" | jq -r '.data.enterprise.organizations.nodes[] | .login' > data/orgs.tmp
