#!/bin/bash

source envs/env_vars.sh

#############################################
# GET list of tenants

ACCESS_TOKEN=$(jq -r .access_token secrets/oauth2-token.json)

tenant_list=$(curl -v "https://api.xero.com/connections" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json")

echo "$tenant_list"
echo "$tenant_list" > secrets/tenant_list.json

#"tenantName":"Wellington Touch Association Incorporated"
