#!/bin/bash

source envs/env-vars.sh

#############################################
# GET contacts

ACCESS_TOKEN=$(jq -r .access_token secrets/oauth2-token.json)

contacts_list=$(curl -v "https://api.xero.com/api.xro/2.0/Contacts" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Xero-tenant-id: ${TENANT_ID}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json")

echo "$contacts_list"
#echo "$contacts_list" > secrets/contacts-list.json


# With filters
#where=EmailAddress="email@example.com"
#https://api.xero.com/api.xro/2.0/Accounts?where=Type%3D%3D%22BANK%22
