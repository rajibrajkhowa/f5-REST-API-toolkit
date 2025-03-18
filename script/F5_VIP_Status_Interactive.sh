#!/bin/bash

# Variables
read -p "Please enter the user ID? " F5_USER
echo "Please enter your password: "
read -s F5_PASS
read -p "Please enter the F5 LB FQDN? " F5_HOST
read -p "Please enter the F5 VIP? " VIRTUAL_ADDRESS

# Function to get the status of a virtual address
get_virtual_address_status() {
    curl -sk -u $F5_USER:$F5_PASS \
    -H "Content-Type: application/json" \
    -X GET "https://$F5_HOST/mgmt/tm/ltm/virtual-address/$VIRTUAL_ADDRESS"
}

# Call the function
VIP_STATUS=$(get_virtual_address_status | jq '.enabled' | tr -d '"')

echo

jq -nc \
 --arg lb_host "$F5_HOST"\
 --arg vip "$VIRTUAL_ADDRESS" \
 --arg vip_status "$VIP_STATUS" \
 '{
    "LB_HOST": $lb_host,
	"VIP": $vip,
    "VIP_ENABLED": $vip_status
  }'

echo
