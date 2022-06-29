#!/bin/bash

source envs/env-vars.sh

#############################################
# POST create invoices

exit 2

ACCESS_TOKEN=$(jq -r .access_token secrets/oauth2-token.json)
#NEW_INVOICES=$(< secrets/invoices-to-create.json)
NEW_INVOICES=$(< secrets/invoices-to-create-juniors.json)

echo "${NEW_INVOICES}"

curl -v -POST \
  --url "https://api.xero.com/api.xro/2.0/Invoices?summarizeErrors=false" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Xero-tenant-id: ${TENANT_ID}" \
  -d "${NEW_INVOICES}"
