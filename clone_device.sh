echo "### Git clone script for phone FP dumps ###"
echo "Script by Juleast"
echo "*Note you need to specify the git repo URL below:"

read -p "Paste URL here: " url
IFS='/' read -r -a url_arr <<< "$url"
IFS='.' read -r -a git_dir_arr <<< "${url_arr[-1]}"
git_dir=${git_dir_arr[0]}

git clone --depth 1 --no-checkout --filter=blob:none ${url}

cd ${git_dir[0]}
branch_out=$(git branch)
IFS=' ' read -r -a br_arr <<< "$branch_out"
br=${br_arr[-1]}

echo "### Try to get build.prop from system dirs ###"
git checkout $br -- system/build.prop
git checkout $br -- system/system/build.prop

echo "### Try to get build.prop from system/product dirs ###"
git checkout $br -- system/system/product/build.prop
git checkout $br -- system/product/build.prop

echo "### Try to get build.prop from vendor dirs ###"
git checkout $br -- vendor/build.prop 


echo Rename and move files...
if [ -d "system/product" ]; then
  mv system/product/build.prop ./product-build.prop
elif [ -d "system/system/product" ]; then
  mv system/system/product/build.prop ./product-build.prop
fi

if [ -d "system" ]; then
  mv system/build.prop ./build.prop
  if [ -d "system/system" ]; then
    mv system/system/build.prop ./build.prop
    rm -rf system
  fi
  rm -rf system
fi

if [ -d "vendor" ]; then
  mv vendor/build.prop ./vendor-build.prop
  rm -rf vendor
fi

cd ../
