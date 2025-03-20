#! /bin/bash


if [[ -f "cred.txt" ]];

then
  source cred.txt
else
   touch cred.txt
   USER=$(echo $HOME | sed -e 's\/home/\\g')
   echo "export F5_USER="$USER"">> cred.txt
   echo  "Enter your TACACS password"
   read -s PASS
   echo "export F5_PASS="$PASS"" >> cred.txt
   source cred.txt
fi



exit_tool()

{

if [ -f "final_output.txt" ];

then
   rm final_output.txt
   rm cred.txt
   exit
else
   exit
fi

}

vip_details()

{

./script/F5_VIP_Details_Interactive.bash

}


vip_status()

{

./script/F5_VIP_Status_Interactive.bash

}

vs_status()

{

./script/F5_VS_Status_Interactive.bash

}

pool_status()

{

./script/F5_Pool_Status_Interactive.bash

}


pool_member_status()

{

./script/F5_Pool_Member_Status_Interactive.bash

}

vs_cert_binding()

{

./script/F5_VS_Cert_Bindings_Interactive.bash

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

TIP: If you don't know the VIP, Node Pool and Virtual Server naming format in LB choose option-1 to extract the relevant details first before choosing other options

Choose 0 to exit the tool
Choose 1 to get VIP details (Virtual Server & Node Pool) mapped to a VIP
Choose 2 to check status of a given VIP or Virtual Address
Choose 3 to check the status of a given Virtual Server
Choose 4 to check the status of a given Node Pool
Choose 5 to check the status of Pool Members of a given Node Pool
Choose 6 to check Virtual Server and Certificate bindings
"
echo

read -p "Please enter the option? " OPTION

echo

case "$OPTION" in
(0)   exit_tool;;
(1)   vip_details;;
(2)   vip_status;;
(3)   vs_status;;
(4)   pool_status;;
(5)   pool_member_status;;
(6)   vs_cert_binding;;
esac
echo
echo "#############################################"

done
