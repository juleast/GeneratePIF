#!/bin/bash
# PIFGenerator by Juleast @ https://github.com/juleast
# Scripts to generate pif config fingerprints

# Run first script
echo -e "### Clone device dump repo first ### \n"
. clone_device.sh

return_code=$?
case "$return_code" in
  "1")
    echo -e "# Previous script returned error so next script will not run. \n#"
    echo -e "### Exiting script... ###"
    return 1
    ;;
  *)
    # Run second script
    echo -e "\n### Generate pif.json file ### \n"
    . gen_pif_custom.sh
    echo -e "\nAll scripts has finished running"
    ;;    
esac

