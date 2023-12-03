#!/bin/bash
# PIFGenerator by Juleast @ https://github.com/juleast
# Scripts to generate pif config fingerprints

# Run first script
echo -e "### Clone device dump repo first ### \n"
. clone_device.sh

# Run second script
echo -e "### Generate pif.json file ### \n"
. gen_pif_custom.sh

echo -e "\nAll scripts has finished running"