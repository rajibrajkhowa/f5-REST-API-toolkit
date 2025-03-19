#! /bin/bash

vip_status()

{

./script/F5_VIP_Status_Interactive.sh

}

vs_status()

{

./script/F5_VS_Status_Interactive.sh

}

pool_status()

{

./script/F5_Pool_Status_Interactive.sh

}


pool_member_status()

{

./script/F5_Pool_Member_Status_Interactive.sh

}

vs_cert_binding()

{

./script/F5_VS_Cert_Bindings_Interactive.sh

}

while [ 1 ]

do

USER=$(logname)

SYSNAME=$(hostname)

DATE=$(date)

echo "Hi $USER you are logged into $SYSNAME on $DATE"
echo
echo "Welcome to the frontend of F5 Loadbalacer Toolkit"
echo

echo "
Which tool you want to use today for analysis ?

Choose 1 to check status of a given VIP or Virtual Address
Choose 2 to check the status of a given Virtual Server
Choose 3 to check the status of a given Node Pool
Choose 4 to check the status of Pool Members of a given Node Pool
Choose 5 to check Virtual Server and Certificate bindings
"
echo

read -p "Please enter the option? " OPTION

echo

case "$OPTION" in
(1)   vip_status;;
(2)   vs_status;;
(3)   pool_status;;
(3)   pool_member_statusstatus;;
(5)   vs_cert_binding;;
esac
echo
echo "#############################################"

done

exit
