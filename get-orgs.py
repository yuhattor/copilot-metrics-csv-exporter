import os
from dotenv import load_dotenv
from python_graphql_client import GraphqlClient

load_dotenv()
TOKEN = os.environ.get("GH_TOKEN")
enterprise_slug = "customer-success-architects-ea-sandbox"
client = GraphqlClient(endpoint="https://api.github.com/graphql")

def get_orgs_query(after=None):
    return """
    query {
        enterprise(slug: "ENTERPRISE_SLUG") {
            organizations(first: 100, after:AFTER) {
                nodes {
                    login
                }
                pageInfo {
                    hasNextPage
                    endCursor
                }
            }
        }
    }
    """.replace(
        "AFTER", f'"{after}"' if after else "null"
    ).replace(
        "ENTERPRISE_SLUG", enterprise_slug
	)

organizations = []
hasNextPage = True
afterCursor = None

while hasNextPage:
    data = client.execute(
        query=get_orgs_query(afterCursor),
        headers={"Authorization": f"Bearer {TOKEN}"},
    )
    if (
        "enterprise" in data["data"]
        and "organizations" in data["data"]["enterprise"]
        and "nodes" in data["data"]["enterprise"]["organizations"]
    ):
        for org in data["data"]["enterprise"]["organizations"]["nodes"]:
            organizations.append({"name": org["login"]})
    else:
        print("Response missing expected field. Got:")
        print(data)
    hasNextPage = data["data"]["enterprise"]["organizations"]["pageInfo"]["hasNextPage"]
    afterCursor = data["data"]["enterprise"]["organizations"]["pageInfo"]["endCursor"]

# get the list of organizations and save them in the orgs.tmp.txt file
with open("data/orgs.tmp", "w") as f:
		for org in organizations:
				f.write(org["name"] + "\n")
