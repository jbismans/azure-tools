#!/bin/bash
# Tested using bash version 4.1.5

for ((i=0;i<=15;i++)); 
do 
   # your-unix-command-here
   echo "Deleting resourcegroup student$i-RG"
   #az group delete --resource-group "student$i-RG" --no-wait --yes
   az group delete --resource-group "student$i-RG" --yes
done
