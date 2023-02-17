#!/bin/bash
# Stop running when command returns error
set -e

echo -n "Enter location (e.g. westeurope): "
stty_orig=`stty -g` # save original terminal setting.
read location         # read the location
stty $stty_orig     # restore terminal setting.
if [ -z "$location" ]
then
    location="westeurope"
fi

echo -n "Enter the publisher: "
stty_orig=`stty -g` # save original terminal setting.
read publisher         # read the location
stty $stty_orig     # restore terminal setting.

az vm image list --all --output table --location $location --publisher $publisher