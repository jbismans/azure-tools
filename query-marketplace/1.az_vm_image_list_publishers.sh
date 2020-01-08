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

az vm image list-publishers --output table --location $location