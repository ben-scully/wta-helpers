#!/bin/bash

source envs/env_vars.sh

#############################################
# GET contacts

ACCESS_TOKEN=$(jq -r .access_token secrets/oauth2_token.json)

contacts_list=$(curl -v "https://api.xero.com/api.xro/2.0/contacts?summaryOnly=True" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Xero-tenant-id: ${TENANT_ID}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json")

echo "$contacts_list"
echo 'Remember that "contacts?summaryOnly=True" not the same as "/Contacts"'
echo "$contacts_list" > secrets/contacts_list.json


# With filters
#where=EmailAddress="email@example.com"
#https://api.xero.com/api.xro/2.0/Accounts?where=Type%3D%3D%22BANK%22
