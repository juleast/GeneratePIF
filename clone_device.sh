#!/system/bin/sh
#
# A repo URL has to be inputed in the input line.
# Get the repo URL from the Android dumps repo (https://dumps.tadiphone.dev/dumps/)
# Then go to brand_name --> device_name --> clone button.

# single file checkouts for inputed repo
checkout() {
  echo "### Try to get build.prop from system dirs ###"
  echo
  git checkout $br -- system/build.prop
  git checkout $br -- system/system/build.prop
  echo
  echo "### Try to get build.prop from system/product dirs ###"
  echo
  git checkout $br -- system/system/product/build.prop
  git checkout $br -- system/product/build.prop
  echo
  echo "### Try to get build.prop from vendor dirs ###"
  echo
  git checkout $br -- vendor/build.prop 
  git checkout $br -- system/vendor/build.prop

  rename
}

# rename and move files that are clones
rename() {
  echo Rename and move files...
  if [ -f "system/product/build.prop" ]; then
    mv system/product/build.prop ./product-build.prop
  elif [ -f "system/system/product/build.prop" ]; then
    mv system/system/product/build.prop ./product-build.prop
  fi

  if [ -f "system/build.prop" ]; then
    mv system/build.prop ./
  elif [ -f "system/system/build.prop" ]; then
    mv system/system/build.prop ./
  fi

  if [ -f "system/vendor/build.prop" ]; then
      mv system/vendor/build.prop ./vendor-build.prop
  fi
  if [ -f "vendor/build.prop" ]; then
    mv vendor/build.prop ./vendor-build.prop
  fi

  delete
}

# delete empty folders when finished
delete() {
  if [ -d "system" ]; then
  rm -rf system
  fi
  if [ -d "vendor" ]; then
    rm -rf vendor
  fi
  # Navigate to parent directory
  cd ../
}

echo "### Git clone script for phone FP dumps ###"
echo -e "Script by Juleast @ https://github.com/juleast \
        \n"

# main script
read -p "Paste repo URL here: " url
IFS='/' read -r -a url_arr <<< "$url"
IFS='.' read -r -a git_dir_arr <<< "${url_arr[-1]}"
git_dir=${git_dir_arr[0]}

git clone --depth 1 --no-checkout --filter=blob:none ${url}

cd ${git_dir[0]}
branch_out=$(git branch)
IFS=' ' read -r -a br_arr <<< "$branch_out"
br=${br_arr[-1]}

checkout
