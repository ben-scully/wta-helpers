#!/bin/bash

source envs/env-vars.sh

#############################################
# POST create contacts

ACCESS_TOKEN=$(jq -r .access_token secrets/oauth2-token.json)
#NEW_CONTACTS=$(< secrets/contacts-to-create.json)
NEW_CONTACTS=$(< secrets/contacts-to-create-juniors.json)

echo "${NEW_CONTACTS}"

new_contacts_list=$(curl -v -POST \
  --url "https://api.xero.com/api.xro/2.0/Contacts" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Xero-tenant-id: ${TENANT_ID}" \
  -d "${NEW_CONTACTS}")

echo "$new_contacts_list"
echo "$new_contacts_list" > secrets/contacts-list-juniors.json
