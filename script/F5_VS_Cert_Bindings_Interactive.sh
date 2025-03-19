#!/bin/bash

# Variables
read -p "Please enter the User ID? " F5_USER
echo  "Please enter the password? "
read -s F5_PASS
read -p "Please enter the F5 LB FQDN? " F5_HOST
read -p "Please enter the F5 Virtual Server Name? " VIRTUAL_SERVER


# Function to get the status of a virtual server
get_virtual_server_profile() {
    curl -sk -u $F5_USER:$F5_PASS \
    -H "Content-Type: application/json" \
    -X GET "https://$F5_HOST/mgmt/tm/ltm/virtual/$VIRTUAL_SERVER/profiles"
}

get_client_ssl_cert() {
    curl -sk -u $F5_USER:$F5_PASS \
    -H "Content-Type: application/json" \
    -X GET "https://$F5_HOST/mgmt/tm/ltm/profile/client-ssl/$PROFILE"
}

get_client_cert_detail() {
    curl -sk -u $F5_USER:$F5_PASS \
    -H "Content-Type: application/json" \
    -X GET "https://$F5_HOST/mgmt/tm/sys/file/ssl-cert/$CERT"
}



# Call the function
PROFILE=$(get_virtual_server_profile | jq '.items[0].name' | tr -d '"')

PREFIX="cssl"

if [[ $PROFILE == "$PREFIX"* ]]; then
   VIP_TYPE="SSL"
   CERT=$(get_client_ssl_cert | jq '.cert' | tr -d '"' | sed 's\/Common/\\')
   sleep 5
   CERT_EXPIRY=$(get_client_cert_detail | jq '.expirationString' | tr -d '"')
else
   VIP_TYPE="TCP VIP"
   CERT="NULL"
   CERT_EXPIRY="NULL"
fi

jq -nc \
 --arg lb_host "$F5_HOST"\
 --arg vs "$VIRTUAL_SERVER" \
 --arg profile "$PROFILE" \
 --arg vip_type "$VIP_TYPE" \
 --arg cert "$CERT" \
 --arg cert_expiry "$CERT_EXPIRY" \
 '{
    "LB HOST": $lb_host,
    "VS": $vs,
    "PROFILE": $profile,
    "VIP_TYPE": $vip_type,
    "CERT": $cert,
    "CERT_EXPIRY": $cert_expiry
  }'
