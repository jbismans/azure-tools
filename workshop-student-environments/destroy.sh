#!/bin/bash
echo "
##############################################################################################################
#
# Workshop student environment
#
##############################################################################################################
"

# Stop running when command returns error
set -e

STATE="terraform.tfstate"

cd terraform/
echo ""
echo "==> Starting Terraform deployment"
echo ""

echo ""
echo "==> Terraform init"
echo ""
terraform init

echo ""
echo "==> Terraform plan -destroy"
echo ""
#terraform plan -var "LOCATION=$DEPLOY_LOCATION" -destroy
terraform plan -destroy

echo -n "Do you want to continue? Type yes: "
stty_orig=`stty -g` # save original terminal setting.
read continue         # read the location
stty $stty_orig     # restore terminal setting.

if [[ $continue == "yes" ]]
then
    echo ""
    echo "==> Terraform destroy"
    echo ""
    terraform destroy -auto-approve 
else
    echo "--> ERROR: Destroy cancelled ..."
    exit $rc;
fi