#!/bin/bash

source envs/env_vars.sh

#############################################
# POST create contacts

exit 2

ACCESS_TOKEN=$(jq -r .access_token secrets/oauth2_token.json)
#NEW_CONTACTS=$(< secrets/contacts_to_create.json)
NEW_CONTACTS=$(< secrets/contacts_to_create_juniors.json)

echo "${NEW_CONTACTS}"

new_contacts_list=$(curl -v -POST \
  --url "https://api.xero.com/api.xro/2.0/Contacts?summarizeErrors=false" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Xero-tenant-id: ${TENANT_ID}" \
  -d "${NEW_CONTACTS}")

echo "$new_contacts_list"
echo "$new_contacts_list" > secrets/contacts_list_juniors.json
