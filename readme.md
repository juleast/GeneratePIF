## Automatic script for PIF config generation

### What is this?

This repo has scripts for generating custom PIF config files to use with PIF v14.

### How to use this?

The script has two files. The first one is `clone_device.sh` and the second is `gen_pif_custom.sh` modified from [@osm0sis](https://github.com/osm0sis)' original `gen_pif_custom.sh`

#### The structure

1. The first script clones a repo from a device repo link the user will provide from [the dump repo](https://dumps.tadiphone.dev/dumps/).
   It inits the git repo without checkout so that we don't have to download unnecessary files.

   - Make sure the script is exectuable first:

   ```bash
   chmod +x clone_device.sh
   # Then run
   ./device_clone.sh

   # Pro tip:
   # If you are lazy you can always type the first couple of lines and
   # add the '*' to search for the trailing letters/characters of the file
   # name as long as no file has a similar name to the script
   ./device*
   ```

2. We only need two files for `gen_pif_custom.sh` to generate the config file:

   - `build.prop` from `system` and `vendor` directories are cloned.
   - For just in case, the `build.prop` from `system/product` is also cloned if available.
   - \*Do not worry if the script outputs some errors. As long as the end result has at least 2 files, you are good.

3. The script will then move and rename files appropriately for the second script to use in the root of the repo directory.

4. Run the second script.

   - Make sure the script is exectuable first:

   ```bash
   chmod +x gen_pif_custom.sh
   # Then run
   ./gen_pif.custom.sh

   # Or use the shortened version
   ./gen*
   ```

5. Running the second script will output a list of directories in the root of the script's directory.

6. Inputing the number corresponding to the desired directory will navigate to it and work its magic.

7. You will find your `custom.pif.json` file in the directory you chose in step 5.

8. Rename this file to `pif.json` and move it inside `/data/adb` folder on your device using your favorite root explorer
   - if you know how to use adb and shell commands:
   ```bash
   cp path_to_your_file /data/adb/
   ```

#### For manual generation

If you would like to take on the tedious task of finding each prop value and then copying it to your json file, here is a list of prop names that each json config property corresponds to:

- PRODUCT:
  - ro.product.name
  - ro.product.system.name
  - ro.product.product.name
- DEVICE:
  - ro.product.device
  - ro.product.system.device
  - ro.product.product.name
- MANUFACTURER:
  - ro.product.manufacturer
  - ro.product.system.manufacturer
  - ro.product.product.manufacturer
- BRAND:
  - ro.product.brand
  - ro.product.system.brand
  - ro.product.product.brand
- MODEL:
  - ro.product.model
  - ro.product.system.model
  - ro.product.product.model
- FINGERPRINT:
  - ro.build.fingerprint
  - ro.system.build.fingerprint
  - ro.product.build.fingerprint

Then save your file like this:

```json
{
  "PRODUCT": "taimen",
  "DEVICE": "taimen",
  "MANUFACTURER": "Google",
  "BRAND": "google",
  "MODEL": "Pixel 2 XL",
  "FINGERPRINT": "google/taimen/taimen:8.1.0/OPM4.171019.021.R1/4833808:user/release-keys",
  "SECURITY_PATCH": "2018-07-05",
  "FIRST_API_LEVEL": "26"
}
```

\*Above fingerprint is already banned and is only an example.

# Credits

- [@osm0sis](https://github.com/osm0sis) for the `gen_pif_custom.sh` script on [xda](https://xdaforums.com/t/tools-zips-scripts-osm0sis-odds-and-ends-multiple-devices-platforms.2239421/post-89173470)
