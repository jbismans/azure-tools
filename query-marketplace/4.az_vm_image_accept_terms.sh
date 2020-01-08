# Stop running when command returns error
set -e

echo -n "Enter the urn: "
stty_orig=`stty -g` # save original terminal setting.
read urn         # read the location
stty $stty_orig     # restore terminal setting.

az vm image terms accept --urn $urn