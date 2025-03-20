#!/bin/bash

# Variables
read -p "Please enter the F5 LB FQDN? " F5_HOST
read -p "Please enter the F5 Node Pool name? " POOL


# Function to get the status of a pool
get_pool_status() {
    curl -sk -u $F5_USER:$F5_PASS \
    -H "Content-Type: application/json" \
    -X GET "https://$F5_HOST/mgmt/tm/ltm/pool/~Common~$POOL/stats"
}

echo

# Call the function

get_pool_status > temp.txt

POOL_AVAILABILITY_STATUS=$(cat temp.txt | jq '.entries[].nestedStats.entries | ."status.availabilityState"' | jq '.description' | tr -d '"')

POOL_STATUS=$(cat temp.txt | jq '.entries[].nestedStats.entries | ."status.enabledState"' | jq '.description' | tr -d '"')

echo

jq -nc \
 --arg lb_host "$F5_HOST"\
 --arg pool "$POOL" \
 --arg availability "$POOL_AVAILABILITY_STATUS" \
 --arg pool_status "$POOL_STATUS" \
 '{
    "LB HOST": $lb_host,
    "POOL": $pool,
    "POOL_AVAILABILITY_STATUS": $availability,
    "POOL_STATUS": $pool_status
  }'

rm temp.txt

echo
