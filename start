#!/bin/bash
# PIFGenerator by Juleast @ https://github.com/juleast
# Scripts to generate pif config fingerprints
# The generate() function segment is based on gen_pif_custom.sh by osm0sis @ xda-developers

# Remember original path
og_path="$(pwd)"

# Error message function
dead() {
  echo -e "\nProgram ended prematurely due to the following error:\n$@"
  exit 1
}

# Easter egg
megamind() {
  local message="$1"
  echo -e "———————————${message}?———————————"
  echo -e "⠀⣞⢽⢪⢣⢣⢣⢫⡺⡵⣝⡮⣗⢷⢽⢽⢽⣮⡷⡽⣜⣜⢮⢺⣜⢷⢽⢝⡽⣝"
  echo -e "⠸⡸⠜⠕⠕⠁⢁⢇⢏⢽⢺⣪⡳⡝⣎⣏⢯⢞⡿⣟⣷⣳⢯⡷⣽⢽⢯⣳⣫⠇"
  echo -e "⠀⠀⢀⢀⢄⢬⢪⡪⡎⣆⡈⠚⠜⠕⠇⠗⠝⢕⢯⢫⣞⣯⣿⣻⡽⣏⢗⣗⠏⠀"
  echo -e "⠀⠪⡪⡪⣪⢪⢺⢸⢢⢓⢆⢤⢀⠀⠀⠀⠀⠈⢊⢞⡾⣿⡯⣏⢮⠷⠁⠀⠀"
  echo -e "⠀⠀⠀⠈⠊⠆⡃⠕⢕⢇⢇⢇⢇⢇⢏⢎⢎⢆⢄⠀⢑⣽⣿⢝⠲⠉⠀⠀⠀⠀"
  echo -e "⠀⠀⠀⠀⠀⡿⠂⠠⠀⡇⢇⠕⢈⣀⠀⠁⠡⠣⡣⡫⣂⣿⠯⢪⠰⠂⠀⠀⠀⠀"
  echo -e "⠀⠀⠀⠀⡦⡙⡂⢀⢤⢣⠣⡈⣾⡃⠠⠄⠀⡄⢱⣌⣶⢏⢊⠂⠀⠀⠀⠀⠀⠀"
  echo -e "⠀⠀⠀⠀⢝⡲⣜⡮⡏⢎⢌⢂⠙⠢⠐⢀⢘⢵⣽⣿⡿⠁⠁⠀⠀⠀⠀⠀⠀⠀"
  echo -e "⠀⠀⠀⠀⠨⣺⡺⡕⡕⡱⡑⡆⡕⡅⡕⡜⡼⢽⡻⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
  echo -e "⠀⠀⠀⠀⣼⣳⣫⣾⣵⣗⡵⡱⡡⢣⢑⢕⢜⢕⡝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
  echo -e "⠀⠀⠀⣴⣿⣾⣿⣿⣿⡿⡽⡑⢌⠪⡢⡣⣣⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
  echo -e "⠀⠀⠀⡟⡾⣿⢿⢿⢵⣽⣾⣼⣘⢸⢸⣞⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
  echo -e "⠀⠀⠀⠀⠁⠇⠡⠩⡫⢿⣝⡻⡮⣒⢽⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
  echo -e "—————————————————————————————"
}

# Main pif file generator function
generate() {
  item() { echo -e "\n- $@"; }
  die() {
    echo -e "\n\n! $@"
    if $short || $manual; then
      exit 1
    else
      return 1
    fi
  }
  file_getprop() {
    grep "^$2=" "$1" 2>/dev/null | tail -n1 | cut -d= -f2-
  }

  main() {
    if [ -d "$1" ]; then
      DIR="$1/dummy";
      LOCAL="$(readlink -f "$PWD")";
      shift;
    else
      case "$0" in
        *.sh) DIR="$0";;
          *) DIR="$(lsof -p $$ 2>/dev/null | grep -o '/.*gen_pif_custom.sh$')";;
      esac;
    fi;
    DIR=$(dirname "$(readlink -f "$DIR")");
    if [ "$LOCAL" ]; then
      item "Using prop directory: $DIR";
      item "Using output directory: $LOCAL";
      LOCAL="$LOCAL/";
    fi;
    echo $DIR
    cd "$DIR";

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
      generic)
        echo -e "Generic /system/build.prop values found, using values from product-build.prop..."
        DEVICE=""
        ;;
    esac;

    [ -z "$PRODUCT" ] && PRODUCT=$(file_getprop product-build.prop ro.product.product.name);
    [ -z "$DEVICE" ] && DEVICE=$(file_getprop product-build.prop ro.product.product.device);
    [ -z "$MANUFACTURER" ] && MANUFACTURER=$(file_getprop product-build.prop ro.product.product.manufacturer);
    [ -z "$BRAND" ] && BRAND=$(file_getprop product-build.prop ro.product.product.brand);
    [ -z "$MODEL" ] && MODEL=$(file_getprop product-build.prop ro.product.product.model);
    [ -z "$FINGERPRINT" ] && FINGERPRINT=$(file_getprop product-build.prop ro.product.build.fingerprint);

    [ -z "$PRODUCT" ] && PRODUCT=$(file_getprop system-build.prop ro.product.system.name);
    [ -z "$DEVICE" ] && DEVICE=$(file_getprop system-build.prop ro.product.system.device);
    [ -z "$MANUFACTURER" ] && MANUFACTURER=$(file_getprop system-build.prop ro.product.system.manufacturer);
    [ -z "$BRAND" ] && BRAND=$(file_getprop system-build.prop ro.product.system.brand);
    [ -z "$MODEL" ] && MODEL=$(file_getprop system-build.prop ro.product.system.model);
    [ -z "$FINGERPRINT" ] && FINGERPRINT=$(file_getprop system-build.prop ro.system.build.fingerprint);

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
      if [ ! -f vendor-build.prop ]; then
        echo -e "No vendor-build.prop file found. Falling back to build.prop ...";
      fi
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


    if [ -f "$LOCAL"pif.$FORMAT ]; then
      item "Removing existing custom pif.$FORMAT ...";
      rm -f "$LOCAL"pif.$FORMAT;
    fi;

    item "Writing new custom pif.$FORMAT ...";
    [ "$FORMAT" == "json" ] && echo '{' | tee -a "$LOCAL"pif.json;
    for PROP in $LIST; do
      case $FORMAT in
        json) eval echo '\ \ \"$PROP\": \"'\$$PROP'\",';;
        prop) eval echo $PROP=\$$PROP;;
      esac;
    done | sed '$s/,//' | tee -a "$LOCAL"pif.$FORMAT;
    [ "$FORMAT" == "json" ] && echo '}' | tee -a "$LOCAL"pif.json;

    if [ -e "/system/build.prop" ] && $short; then
      echo -e "Detected Android as terminal environment."
      if [ ! command -v su &> /dev/null ]; then
        echo -e "No su binary detected!"
        echo -e "Are you sure there is superuser access?"
        echo -e "To copy your result file, run short mode again after"
        echo -e "granting superuser access to your terminal."
        dead "No su binary."
      else
        echo -e "Backing up current pif.json file and copying new one..."
        su -c mv /data/adb/pif.json /data/adb/bak.pif.json
        su -c cp "$LOCAL"pif.json /data/adb/pif.json
        echo "!!! Make sure to kill GMS service to test your fingerprint. !!!"
        echo -e "Copy and paste this command: su -c killall com.google.android.gms.unstable\n"
      fi
    fi
    echo "Done!"
    cd ../
  }

  manual_gen() {
    dir_arr=("no")
    readarray -t temp_arr < <(ls -F | grep "/$" | cut -d'/' -f1)
    dir_arr+=(${temp_arr[@]})
    if [ "${#dir_arr[@]}" -lt 2 ]; then
      echo -e "No directories found. Did you clone a repo first?"
      exit 1
    fi
    echo -e "# Choose your cloned directory by referencing the number next to\
      \n# each directory name. (do not select any empty name directories)";
    for ((a = 1 ; a < ${#dir_arr[@]} ; a++)); do
      echo "${a}. ${dir_arr[$a]}"
    done

    echo ""
    read -p "Enter number: " arr_index
    int="^[0-9]+$"
    if [[ "$arr_index" =~ $int ]]; then
      if [ "$arr_index" -gt "${#dir_arr[@]}" ] || [ "$arr_index" -lt 0 ]; then
        echo -e "Invalid index!"
        echo -e "Exiting..."
        exit 1
      else
        cd ${dir_arr[$arr_index]}
        main
      fi
    else
      echo "Not a number!"
      exit 1
    fi

  }

  if $manual; then
    manual_gen
  else
    main
  fi
}

# Main function to clone device repo
clone_repo() {
  # Take repo link as input beforehand
  local input="$1"
  # Single file checkouts for inputed repo
  checkout() {
    echo -e "\n# Try to get build.prop from system dirs"
    git checkout "$br" -- system/build.prop
    git checkout "$br" -- system/system/build.prop

    echo -e "\n# Try to get build.prop from system/product dirs"
    git checkout "$br" -- system/system/product/build.prop
    git checkout "$br" -- system/product/build.prop
    git checkout "$br" -- product/etc/build.prop

    echo -e "\n# Try to get build.prop from vendor dirs"
    echo
    git checkout "$br" -- vendor/build.prop
    git checkout "$br" -- system/vendor/build.prop

    rename
  }
  # Rename and move files that are clones
  rename() {
    echo -e "\n# Rename and move files..."
    if [ -f "system/product/build.prop" ]; then
      mv system/product/build.prop ./product-build.prop
    elif [ -f "system/system/product/build.prop" ]; then
      mv system/system/product/build.prop ./product-build.prop
    elif [ -f "product/etc/build.prop" ]; then
      mv product/etc/build.prop ./product-build.prop
    fi

    if [ -f "system/build.prop" ]; then
      mv system/build.prop ./build.prop
    fi
    if [ -f "system/system/build.prop" ]; then
      mv system/system/build.prop ./system-build.prop
    fi

    if [ -f "system/vendor/build.prop" ]; then
        mv system/vendor/build.prop ./vendor-build.prop
    fi
    if [ -f "vendor/build.prop" ]; then
      mv vendor/build.prop ./vendor-build.prop
    fi

    delete
  }
  # Delete empty folders when finished
  delete() {
    if [ -d "product" ]; then
      rm -rf product
    fi
    if [ -d "system" ]; then
      rm -rf system
    fi
    if [ -d "vendor" ]; then
      rm -rf vendor
    fi

    if $manual; then
      cd ../
    fi
  }
  # Main code for cloning
  # Check for modes
  if $file; then
    url=$input
  elif $short || $manual; then
    read -p "Paste repo URL here (or press Ctrl+C to stop): " url
  else
    megamind "No arguments"
    exit 1
  fi

  # Check for proper URLs
  if [ "$url" = ""  ]; then
    if $file; then
      echo -e "!!! Repo link missing !!!"
      echo -e "Skipping..."
      return 1
    fi
    megamind "No repo link"
    echo -e "# Please Note!!"
    echo -e "# Make sure you are pasting the proper URL" \
    "\n# URL formats such as https://dumps.tadiphone.dev/dumps/asus/asus_i007_1.git"
    echo -e "# Rerun program after copying the correct URL"
    exit 1
  elif [[ $(echo "$url" | grep "https://") != "" ]] && [[ $(echo "$url" | grep ".git") != "" ]]; then
    IFS='/' read -r -a url_arr <<< "$url"
    last_index=$(( ${#url_arr[@]} - 1 ))
    last_part="${url_arr[last_index]}"
    git_dir=(${last_part//.git/})
    # This is to suppress git screaming 'fatal directory not empty'
    if [ -d "${git_dir[0]}" ]; then
      echo "Directory already exists. Skipping clone..."
    else
      git clone --depth 1 --no-checkout --filter=blob:none ${url}
    fi
    # Navigate to cloned directory
    cd ${git_dir[0]}
    br=$(git rev-parse --abbrev-ref HEAD)

    # Checkout with outputs suppressed to a output file
    checkout &> out.txt
  else
    echo -e "# Invalid URL!"
    echo -e "# Please rerun script and paste a valid git URL."
    return 1
  fi
}

# Function to print usage help message
usage() {
  local usage_only="$1"
  if [ "$usage_only" = "yes" ]; then
    echo -e "Usage: $(basename "$0") [-m option] or [-s] or [-f file]"
  else
    echo -e "Usage: $(basename "$0") [-m option] or [-s] or [-f file]"
    echo -e "See 'start -h' for help"
  fi
}
# Navigate to current shell path just in case
cd $og_path

# Flag functions for each option
manual="false"
short="false"
file="false"
help="false"
flag=""
flag_count=0

line_break=""
read -r lines cols < <(stty size)
# Check terminal length
if [ "$cols" -lt 100 ]; then
  line_break="\n                     "
fi

# The code to take flag input when running the script
while getopts 'm:sf:h' OPT; do
  case "$OPT" in
    m)
      if [ "$3" != "" ]; then
        echo -e "Error: More than one mode supplied."
        usage
        exit 1
      fi
      manual="true"
      flag="$OPT"
      mode=${OPTARG}
      ;;
    s)
      if [ "$2" != "" ]; then
        echo -e "Error: No arguments can be supplied for short mode"
        usage
        exit 1
      fi
      short="true"
      flag="$OPT"
      ;;
    f)
      if [ "$3" != "" ]; then
        echo -e "Error: More than one file supplied."
        usage
        exit 1
      fi
      file="true"
      flag="$OPT"
      filename=${OPTARG}
      ;;
    h)
      if [ "$2" != "" ]; then
        megamind "No brain"
        echo -e "Error: Illegal option."
        usage
        exit 1
      fi
      help="true"
      flag="$OPT"

      ;;
    *)
      flag="$OPT"
      ;;
  esac
  flag_count=$((flag_count + 1))
done
shift $((OPTIND-1))

# Prevent multiple flag inputs
if [ "$flag_count" -gt 1 ]; then
  echo -e "Error: Multiple mutually exclusive flags cannot be used simultaneously.\n"
  usage
  exit 1
fi

# The centralized block of code that brings it all together
case $flag in
  m)
    if [ "$mode" = "pif" ]; then
      generate
    elif [ "$mode" = "clone" ]; then
      clone_repo
    else
      echo -e "Error: Unknown mode $mode. Input a valid argument for -m."
      usage
      exit 1
    fi
    ;;
  s)
    echo -e "----- Short mode -----"
    clone_repo
    generate
    ;;
  f)
    echo -e "----- Bulk generation mode -----"
    if [ -f $filename ]; then
      readarray -t repo_list < <(cat $filename)
      for repo in ${repo_list[@]}; do
        clone_repo $repo
        generate
      done
    else
      echo "Error: File not found. Make sure you have inputed the correct filename or path."
    fi
    ;;
  h)
    usage "yes"
    echo -e " -m [clone, pif]     Manual generation. Select running ${line_break}one functionality at a time.\n"
    echo -e "                     Use the 'clone' option to only ${line_break}clone a repo.\n"
    echo -e "                     Use the 'pif' option to only ${line_break}generate a fingerprint manually.\n"
    echo -e " -s                  Short version. Run the script with ${line_break}less hassle. Just have the repo"
    echo -e "                     link ready in your clipboard.\n"
    echo -e " -f [file-path]      For bulk generation. It requires a ${line_break}text file with a list of device"
    echo -e "                     repo links separated by newlines.\n"
    echo -e " -h                  Prints this screen.\n"
    ;;
  *)
    if [ "$flag" = "" ]; then
      echo -e "Error: Make sure at least one argument is passed and that your argument is not more than one.\n"
      usage
      exit 1
    else
      usage
      exit 1
    fi
    ;;
esac
