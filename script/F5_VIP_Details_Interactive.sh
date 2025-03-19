#!/bin/bash

# Variables
read -p "Please enter the EID#? " F5_USER
echo "Please enter your password: "
read -s F5_PASS
read -p "Please enter the F5 LB FQDN? " F5_HOST
read -p "Please enter the F5 VIP? " VIP

# Function to get the status of a virtual server
get_vs_details() {
    curl -sk -u $F5_USER:$F5_PASS -X POST \
     -H "Content-Type: application/json" \
     -d"{\"command\":\"run\", \"utilCmdArgs\": \"-c 'tmsh list ltm virtual | grep $VIP | grep "vs_"'\"}" \
     https://$F5_HOST/mgmt/tm/util/bash
}

get_va_details() {
    curl -sk -u $F5_USER:$F5_PASS -X POST \
     -H "Content-Type: application/json" \
     -d"{\"command\":\"run\", \"utilCmdArgs\": \"-c 'tmsh list ltm virtual | grep $VIP | grep "va_"'\"}" \
     https://$F5_HOST/mgmt/tm/util/bash
}

get_pool_details() {
    curl -sk -u $F5_USER:$F5_PASS -X POST \
     -H "Content-Type: application/json" \
     -d"{\"command\":\"run\", \"utilCmdArgs\": \"-c 'tmsh list ltm virtual | grep $VIP | grep "pool_"'\"}" \
     https://$F5_HOST/mgmt/tm/util/bash
}


# Call the function
echo "List of the virtual servers mapped to $VIP"
get_vs_details | jq '.commandResult'
echo
echo "List of the virtual address mapped to $VIP"
get_va_details | jq '.commandResult'
echo
echo "List of the node pools mapped to $VIP"
get_pool_details | jq '.commandResult'
