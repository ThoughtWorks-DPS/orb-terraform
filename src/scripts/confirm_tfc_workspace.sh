#!/usr/bin/env bash
set -eo pipefail

echo "debug:"
echo "TFC_ORGANIZATION $TFC_ORGANIZATION"
echo "TFC_WORKSPACE $TFC_WORKSPACE"

# setup curl parameters
tfc_api_url="https://app.terraform.io/api/v2/organizations"
tfc_api_url_workspaces="$tfc_api_url/$TFC_ORGANIZATION/workspaces"
tfc_api_url_workspace_by_name="$tfc_api_url/$TFC_ORGANIZATION/workspaces/$TFC_WORKSPACE"

headers=(
  "Authorization: Bearer $TFE_TOKEN"
  "Content-Type: application/vnd.api+json"
)
post_payload='{ "data": { "attributes": { "name": "'"$TFC_WORKSPACE"'", "execution-mode": "local" }, "type": "workspaces" } }'
patch_payload='{ "data": { "attributes": { "execution-mode": "local" }, "type": "workspaces" } }'

# get the current workspace configuration, if it exists
exists=$(curl --header "${headers[0]}" --header "${headers[1]}" "$tfc_api_url_workspace_by_name")

# workspace does not exist, create it with local-mode setting
if [ "$(echo "$exists" | jq -r .data.attributes.name)" == "null" ]; then
    echo "creating workspace $TFC_WORKSPACE"
    createworkspace=$(curl --header "${headers[0]}" \
                           --header "${headers[1]}" \
                           --request POST \
                           --data "$post_payload" \
                           "$tfc_api_url_workspaces")


      if [ "$(echo "$createworkspace" | jq -r .data.attributes.name)" == "null" ]; then
        echo "error: $createworkspace"
        exit 1
      else
        echo "success: $createworkspace"
        exit 0
      fi
fi

# workspace already exists but is not in local mode, set to local-mode
if [ "$(echo "$exists" | jq -r '.data.attributes["execution-mode"]')" != "local" ]; then
    updateworkspace=$(curl --header "${headers[0]}" \
                           --header "${headers[1]}" \
                           --request PATCH \
                           --data "$patch_payload" \
                           "$tfc_api_url_workspace_by_name")

    if [[ $(echo "$updateworkspace" | jq -r .data.attributes.name) == "null" ]]; then
      echo "error: $updateworkspace"
      exit 1
    else
      echo "success: $updateworkspace"
      exit 0
    fi
fi
