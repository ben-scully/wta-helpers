#!/bin/bash

source envs/env_vars.sh

#############################################
# GET request Auth Code

XERO_AUTH_CODE_URL="https://login.xero.com/identity/connect/authorize?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&scope=${SCOPES// /%20}&state=${STATE}"
echo "$XERO_AUTH_CODE_URL"
open -a "Google Chrome" "$XERO_AUTH_CODE_URL"
