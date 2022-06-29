#!/bin/bash

source envs/env-vars.sh

#############################################
# POST request a Refresh Token

REFRESH_TOKEN=$(jq -r .refresh_token secrets/oauth2-token.json)
CLIENT_SECRET=$(<secrets/client-secret.txt)

refreshed_oauth2_access_token=$(curl -v -POST \
  --url "https://identity.xero.com/connect/token" \
  -u "${CLIENT_ID}:${CLIENT_SECRET}" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d grant_type=refresh_token \
  -d refresh_token=${REFRESH_TOKEN})

echo "$refreshed_oauth2_access_token"
echo "$refreshed_oauth2_access_token" > secrets/oauth2-token.json

#  -H 'Content-Type: application/x-www-form-urlencoded' \
