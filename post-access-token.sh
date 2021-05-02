#!/bin/bash

source envs/env-vars.sh

#############################################
# POST exchange Auth Code for Access Token

CODE=$(<secrets/code.txt)
CLIENT_SECRET=$(<secrets/client-secret.txt)

oauth2_access_token=$(curl -v -POST \
  --url "https://identity.xero.com/connect/token" \
  -u "${CLIENT_ID}:${CLIENT_SECRET}" \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data grant_type=authorization_code \
  --data redirect_uri=${REDIRECT_URI} \
  --data code=${CODE})

echo "$oauth2_access_token"
echo "$oauth2_access_token" > secrets/oauth2-token.json
