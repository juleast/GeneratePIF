# Automatic script for PIF config generation

#### \*Please read all instructions carefully before asking any questions!

### What is this?

This repo has scripts for generating custom PIF config files to use with PIF v14 and dev versions.

### How to use this?

- You first need to clone the repo and navigate to it:
  ```bash
  git clone https://github.com/juleast/GeneratePIF.git
  # Navigate to the cloned directory
  cd GeneratePIF
  ```
- The script has two files. The first one is `clone_device.sh` and the second is `gen_pif_custom.sh` modified from [@osm0sis](https://github.com/osm0sis)' original `gen_pif_custom.sh`
- **You need to copy a device repo from tadi's device dump (link in step 1) and paste it when prompted after running the first script.**
  - Screenshot instructions --> [click here](https://imgur.com/a/dL88uHQ)

### Termux Users

- For those who want to use the Termux app to run these scripts on your phone, make sure you have the latest F-Droid release. Get it [here](https://f-droid.org/repo/com.termux_118.apk).
- In order to run the script properly on Termux, `git` needs to be properly installed:
  - First update the package mirrors then install git:
    ```bash
    pkg update
    pkg install git
    ```
- If everything was updated and installed correctly, you can proceed to the main instructions as normal.

### The structure

1. Skip running all the scripts individually by running `start.sh` file instead. Running them individually can still be useful if you just want to repeat regenerating the json files only.

   - Make `start.sh` exectuable and run
     ```bash
     chmod +x start.sh
     # Run the script
     ./start.sh
     ```

   * You can skip to [step 8](#step-8) if you run `start.sh` file.

2. The first script clones a repo from a device repo link the user will provide from the dump repo: [https://dumps.tadiphone.dev/dumps/](https://dumps.tadiphone.dev/dumps/).
   It initializes the git repo without checkout so that we don't have to download unnecessary files.

   - Make sure the script is exectuable first:

     ```bash
     chmod +x clone_device.sh
     # Then run
     ./clone_device.sh

     # Pro tip:
     # If you are lazy you can always type the first couple of lines and
     # add the '*' to search for the trailing letters/characters of the file
     # name as long as no file has a similar name to the script
     ./clone*
     ```

3. The required files are cloned individually using `git checkout branch -- filename`. 
    * We only need two files for `gen_pif_custom.sh` to generate the config file:
      - `build.prop` file from `system` and `vendor` directories are cloned.
      - For just in case, the `build.prop` from `system/product` is also cloned if available.
      - Do not worry if the script outputs some errors. As long as the end result has at least 2 files, you are good.
        - In rare cases I have seen the fingerprints generate just fine with only one file but this is not always the case. Make sure to check that the end result produces **ALL** json properties properly. Reference [File format](#file-format) section for more info.

4. The script will then move and rename files appropriately for the second script to use in the **root** of the repo directory.

5. Run the second script.

   - Make sure the script is exectuable first:

     ```bash
     chmod +x gen_pif_custom.sh
     # Then run
     ./gen_pif.custom.sh

     # Or use the shortened version
     ./gen*
     ```

6. Running the second script will output a list of directories in the root of the script's directory for you to choose.

   - You will see something like this:

     ```bash
     ### System build.prop to custom.pif.json/.prop creator ###
     # by osm0sis @ xda-developers
     # and modified by Juleast @ https://github.com/juleast
     #
     # Choose your cloned directory by referencing the number
     # next to each directory name. (ignore .git or empty name directories)
     1. .git
     2. judyp

     Enter number:
     ```

7. Inputting the number corresponding to the desired directory will navigate to it and work its magic.

8. <a name="step-8"></a>You will find your `custom.pif.json` file in the directory you chose in step 7.

    - **For Termux users**, the home directory of Termux is usually hidden in the temp directory. Thus, what I advise is to copy the generated file before you close Termux to avoid confusions and not have to dig through your phone's file manager app.
      - ie. If you cloned and generated a fingerprint for LG V35 (judyp), you will see a folder named `judyp`.
      - Navigate to the directory and copy the file you generated
        ```bash
        cd judyp
        cp custom.pif.json /sdcard/Downloads
        ```

9. Rename this file to `pif.json` and move it inside `/data/adb` folder on your device using your favorite root explorer.
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
  - ro.product.vendor.name
- DEVICE:
  - ro.product.device
  - ro.product.system.device
  - ro.product.product.device
  - ro.product.vendor.device
- MANUFACTURER:
  - ro.product.manufacturer
  - ro.product.system.manufacturer
  - ro.product.product.manufacturer
  - ro.product.vendor.manufacturer
- BRAND:
  - ro.product.brand
  - ro.product.system.brand
  - ro.product.product.brand
  - ro.product.vendor.brand
- MODEL:
  - ro.product.model
  - ro.product.system.model
  - ro.product.product.model
  - ro.product.vendor.model
- FINGERPRINT:
  - ro.build.fingerprint
  - ro.system.build.fingerprint
  - ro.product.build.fingerprint
  - ro.product.vendor.fingerprint
- FIRST_API_LEVEL (The first two items are what are looked for if not found, try finding the fallback values):
  - ro.board.first_api_level
  - ro.board.api_level
  - **Fallback values**:
    - ro.build.version.sdk
    - ro.system.build.version.sdk
    - ro.build.version.sd
    - ro.system.build.version.sd
    - ro.vendor.build.version.sdk
    - ro.product.build.version.sdk

Then save your file like this:

## File format

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
