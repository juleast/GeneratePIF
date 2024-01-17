#!/bin/bash
#
# To be run with the /system/build.prop (build.prop) and
# /vendor/build.prop (vendor-build.prop) from the stock
# ROM of a device you want to spoof values from
echo -e "### System build.prop to custom.pif.json/.prop creator ### \
    \n# by osm0sis @ xda-developers \
    \n# and modified by Juleast @ https://github.com/juleast \n#";

item() { echo -e "\n- $@"; }
die() { 
  echo -e "\n\n! $@"
  return
}
file_getprop() { grep "^$2=" "$1" 2>/dev/null | tail -n1 | cut -d= -f2-; }

main() {
  case $1 in
  json|prop) FORMAT=$1;;
  "") FORMAT=json;;
  esac;
  item "Using format: $FORMAT";

  [ ! -f build.prop ] && [ ! -f system-build.prop -o ! -f product-build.prop ] \
    && die "No build.prop files found in script directory";

  item "Parsing build.prop(s) ...";

  PRODUCT=$(file_getprop build.prop ro.product.name);
  DEVICE=$(file_getprop build.prop ro.product.device);
  MANUFACTURER=$(file_getprop build.prop ro.product.manufacturer);
  BRAND=$(file_getprop build.prop ro.product.brand);
  MODEL=$(file_getprop build.prop ro.product.model);
  FINGERPRINT=$(file_getprop build.prop ro.build.fingerprint);
  FORCE_BASIC_ATTESTATION="false"

  [ -z "$PRODUCT" ] && PRODUCT=$(file_getprop build.prop ro.product.system.name);
  [ -z "$DEVICE" ] && DEVICE=$(file_getprop build.prop ro.product.system.device);
  [ -z "$MANUFACTURER" ] && MANUFACTURER=$(file_getprop build.prop ro.product.system.manufacturer);
  [ -z "$BRAND" ] && BRAND=$(file_getprop build.prop ro.product.system.brand);
  [ -z "$MODEL" ] && MODEL=$(file_getprop build.prop ro.product.system.model);
  [ -z "$FINGERPRINT" ] && FINGERPRINT=$(file_getprop build.prop ro.system.build.fingerprint);

  case $DEVICE in
    generic) die "Generic /system/build.prop values found, rename to system-build.prop and add product-build.prop";;
  esac;

  [ -z "$PRODUCT" ] && PRODUCT=$(file_getprop product-build.prop ro.product.product.name);
  [ -z "$DEVICE" ] && DEVICE=$(file_getprop product-build.prop ro.product.product.device);
  [ -z "$MANUFACTURER" ] && MANUFACTURER=$(file_getprop product-build.prop ro.product.product.manufacturer);
  [ -z "$BRAND" ] && BRAND=$(file_getprop product-build.prop ro.product.product.brand);
  [ -z "$MODEL" ] && MODEL=$(file_getprop product-build.prop ro.product.product.model);
  [ -z "$FINGERPRINT" ] && FINGERPRINT=$(file_getprop product-build.prop ro.product.build.fingerprint);

  if [ -z "$FINGERPRINT" ]; then
    if [ -f build.prop ]; then
      die "No fingerprint found, use a /system/build.prop to start";
    else
      die "No fingerprint found, unable to continue";
    fi;
  fi;
  echo "$FINGERPRINT";

  LIST="PRODUCT DEVICE MANUFACTURER BRAND MODEL FINGERPRINT";

  item "Parsing build UTC date ...";
  UTC=$(file_getprop build.prop ro.build.date.utc);
  [ -z "$UTC" ] && UTC=$(file_getprop system-build.prop ro.build.date.utc);
  date -u -d @$UTC;

  if [ "$UTC" -gt 1521158400 ]; then
    item "Build date newer than March 2018, adding SECURITY_PATCH ...";
    SECURITY_PATCH=$(file_getprop build.prop ro.build.version.security_patch);
    [ -z "$SECURITY_PATCH" ] && SECURITY_PATCH=$(file_getprop system-build.prop ro.build.version.security_patch);
    LIST="$LIST SECURITY_PATCH";
    echo "$SECURITY_PATCH";
  fi;

  item "Parsing build first API level ...";
  FIRST_API_LEVEL=$(file_getprop vendor-build.prop ro.product.first_api_level);
  [ -z "$FIRST_API_LEVEL" ] && FIRST_API_LEVEL=$(file_getprop vendor-build.prop ro.board.first_api_level);
  [ -z "$FIRST_API_LEVEL" ] && FIRST_API_LEVEL=$(file_getprop vendor-build.prop ro.board.api_level);

  if [ -z "$FIRST_API_LEVEL" ]; then
    [ ! -f vendor-build.prop ] && die "No first API level found, add vendor-build.prop";
    item "No first API level found, falling back to build SDK version ...";
    [ -z "$FIRST_API_LEVEL" ] && FIRST_API_LEVEL=$(file_getprop build.prop ro.build.version.sdk);
    [ -z "$FIRST_API_LEVEL" ] && FIRST_API_LEVEL=$(file_getprop build.prop ro.system.build.version.sdk);
    [ -z "$FIRST_API_LEVEL" ] && FIRST_API_LEVEL=$(file_getprop system-build.prop ro.build.version.sdk);
    [ -z "$FIRST_API_LEVEL" ] && FIRST_API_LEVEL=$(file_getprop system-build.prop ro.system.build.version.sdk);
    [ -z "$FIRST_API_LEVEL" ] && FIRST_API_LEVEL=$(file_getprop vendor-build.prop ro.vendor.build.version.sdk);
    [ -z "$FIRST_API_LEVEL" ] && FIRST_API_LEVEL=$(file_getprop product-build.prop ro.product.build.version.sdk);
  fi;
  echo "$FIRST_API_LEVEL";

  if [ "$FIRST_API_LEVEL" -gt 32 ]; then
    item "First API level 33 or higher, resetting to 32 ...";
    FIRST_API_LEVEL=32;
  fi;
  LIST="$LIST FIRST_API_LEVEL";
  if [ "$FIRST_API_LEVEL" -gt 25 ]; then
    item "First API level is Oreo or higher, adding FORCE_BASIC_ATTESTATION property..."
    FORCE_BASIC_ATTESTATION="true"
    LIST="$LIST FORCE_BASIC_ATTESTATION"
  fi;
  

  if [ -f custom.pif.$FORMAT ]; then
    item "Removing existing custom.pif.$FORMAT ...";
    rm -f custom.pif.$FORMAT;
  fi;

  item "Writing new custom.pif.$FORMAT ...";
  [ "$FORMAT" == "json" ] && echo '{' | tee -a custom.pif.json;
  for PROP in $LIST; do
    case $FORMAT in
      json) eval echo '\ \ \"$PROP\": \"'\$$PROP'\",';;
      prop) eval echo $PROP=\$$PROP;;
    esac;
  done | sed '$s/,//' | tee -a custom.pif.$FORMAT;
  [ "$FORMAT" == "json" ] && echo '}' | tee -a custom.pif.json;

  echo
  echo "Done!"
  cd ../
}


case $0 in
  *.sh) shdir="$0";;
     *) shdir="$(lsof -p $$ 2>/dev/null | grep -o '/.*gen_pif_custom.sh$')";;
esac;
shdir=$(dirname "$(readlink -f "$shdir")");

echo -e "# Choose your cloned directory by referencing the number \
  \n# next to each directory name. (ignore .git or empty name directories)";
readarray -t dir_arr < <(find . -maxdepth 1 -type d)
for ((a = 1 ; a < ${#dir_arr[@]} ; a++)); do
  IFS='/' read -r -a split_dir <<< "${dir_arr[$a]}"
  echo "$a. ${split_dir[-1]}"
done

echo ""
read -p "Enter number: " arr_index
if [ "$arr_index" = "" ]; then
  echo "What the...?"
  return
fi
if [ "$arr_index" -gt "${#dir_arr[@]}" ] || [ "$arr_index" -lt 0 ]; then
  echo Invalid index!
  echo Exiting...
  return
elif [ "${dir_arr[$arr_index]}" = "./.git" ]; then
  echo This is a .git folder. Rerun the script.
  return
else
  cd $shdir
  cd ${dir_arr[$arr_index]}
  main
fi
