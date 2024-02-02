# Automatic script for PIF config generation

#### \*Please read all instructions carefully before asking any questions!

### What is this?

- An all in one script that has functions to clone the repo of a device from tadi's phone dump and also generate a fingerprint compatible with Play Integrity Fix Modules v15 and up.
- The propery `FORCE_BASIC_ATTESTATION` is only supported by module versions `v15.x`.
  - If you wish to still use older PIF modules with the generated files, just remove the property in the JSON file.

### How to use this?

- You first need to clone the repo and navigate to it:
  ```bash
  git clone https://github.com/juleast/GeneratePIF.git
  # Navigate to the cloned directory
  cd GeneratePIF
  ```
- Then follow the instructions in the later sections or refer to help menu.
- **You need to copy a device repo from tadi's device dump [here](https://dumps.tadiphone.dev/dumps) and paste it when prompted when running in manual or short mode.**
  - Screenshot instructions --> [click here](https://imgur.com/a/dL88uHQ)

### Termux Users

- For those who want to use the Termux app to run these scripts on your phone, make sure you have the latest F-Droid release. Get it [here](https://f-droid.org/repo/com.termux_118.apk).
- Make sure you allow superuser access to Termux. 
  - **This does not mean you should be running the tool in `su`!**
  - As long as you have allowed superuser access, the tool will do the rest.
- In order to run the script properly on Termux, `git` needs to be properly installed:
  - First update the package mirrors then install git:
    ```bash
    pkg update
    pkg install git
    ```
- If everything was updated and installed correctly, you can proceed to the main instructions as normal.

### The Structure

```bash
$ start -h
Usage: start [-m option] or [-s] or [-f file]
 -m [clone, pif]     Manual generation. Select running one functionality at a time.
                     Use the 'clone' option to only clone a repo.
                     Use the 'pif' option to only generate a fingerprint json manually.

 -s                  Short version. Run the script with less hassle. Just have the repo
                     link ready in your clipboard.

 -f [file-path]      For bulk generation. It requires a text file with a list of device
                     repo links separated by newlines.

 -h                  Prints this screen.

```
- If you need an understanding of how this tool works, see [here](#how-does-this-tool-work).
- #### Setup:
  - Before running the tool, the `start` alias needs to be set to not make redundant `./` calls for running the tool.
    - Run `setup.sh` before using the tool. The setup script also makes sure that `start` is executable.
    - Make `setup.sh` executable and source it so that you can use the alias variable set inside the script.
      ```bash
      # Make setup script exectuable first
      chmod +x setup.sh
      # Run the setup
      source setup.sh
      ```
- #### Manual Mode:
  - Use the `-m` flag with options to run only part of the script.
  - `start -m clone` to use only the repo clone function
    - You will need to supply a repo link when prompted.
  - `start -m pif` to generate a `pif.json` file manually
    - In this mode, you will have to select the directory manually.
    - After generation, manually copy the file either from terminal or using adb depending on your terminal environment.
      ```bash
      # From android terminal environment
      su -c cp device_folder/pif.json /data/adb/
      # From adb
      adb push device_folder/pif.json /data/adb/
      ```
- #### Short mode:
  - Use the `-s` flag to run short mode
  - This mode is semi-automatic. It still prompts for a repo link but JSON file is generated without further interaction.
  - Additionally, if the script detects it is running in an Android environment, it will take a backup of any current `pif.json` file inside `/data/adb/` and then copy the generated `pif.json` file to `/data/adb`.
  - You then need to manually kill GMS service to test your fingerprint with:
    ```bash
    su -c killall com.google.android.gms.unstable
    ```
- #### Bulk generation:
  - Use the `-f` flag to use bulk generation with supplied file.
  - Run the command as, `start -f repo_list.txt`
  - The above command requires a text file to be supplied as argument after the `-f` flag.
  - Example of repo_list.txt
    ```
    https://dumps.tadiphone.dev/dumps/asus/asus_i007_1.git
    https://dumps.tadiphone.dev/dumps/cat/s62pro.git
    https://dumps.tadiphone.dev/dumps/blackview/blackview.git
    https://dumps.tadiphone.dev/dumps/blackview/bv9600.git
    ```

### For manual generation

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
- FIRST_API_LEVEL (The first two items are what are looked for. If not found, try finding the fallback values):
  - ro.board.first_api_level
  - ro.board.api_level
  - **Fallback values**:
    - ro.build.version.sdk
    - ro.system.build.version.sdk
    - ro.build.version.sd
    - ro.system.build.version.sd
    - ro.vendor.build.version.sdk
    - ro.product.build.version.sdk
- FORCE_BASIC_ATTESTATION:
  - This property only works with V15.0 or later versions of PIF module.
  - This property should only be added when the API level is greater than Nougat (25).
  - ie. if FIRST_API_LEVEL=27 add FORCE_BASIC_ATTESTATION=true as last property of JSON file.

Then save your file like this:

### File format

```json
{
  "PRODUCT": "taimen",
  "DEVICE": "taimen",
  "MANUFACTURER": "Google",
  "BRAND": "google",
  "MODEL": "Pixel 2 XL",
  "FINGERPRINT": "google/taimen/taimen:8.1.0/OPM4.171019.021.R1/4833808:user/release-keys",
  "SECURITY_PATCH": "2018-07-05",
  "FIRST_API_LEVEL": "26",
  "FORCE_BASIC_ATTESTATION": true // Only for newer PIF modules
}
```

\*Above fingerprint is already banned and is only an example.

### How does this tool work?

- The tool has two main functions inside:

  - `clone_repo()`
    - This function takes device repo link from [dump repo](https://dumps.tadiphone.dev/dumps).
    - It will clone the repo without checkout to prevent unnecessary files from being downloaded.
    - The required files are cloned individually using `git checkout (branch name) -- filename`.
    - `generate()` function only needs two files to generate the config file:
      - `build.prop` file from system and vendor directories are cloned.
    - As a fail-safe, the `build.prop` from system/product is also cloned if available.
    - If you encounter any errors, you can check the output of the `git checkout` commands that were run in the `out.txt` file that will be inside each repo directory after cloning.
  - `generate()`

    - Based on the script by osm0sis' script on XDA.
    - This is for generating the PIF JSON files.
    - It takes `build.prop` files and parses it to generate a file named `custom.pif.json`.
    - When using manual mode, a prompt to select your desired directory will show on screen.
    - Below is an example prompt:

      ```bash
      $ start -m pif
      # Choose your cloned directory by referencing the number next to
      # each directory name. (do not select any empty name directories)
      1. blackview
      2. bv9600
      3. s62pro

      Enter number:
      ```

## Credits and other info

- Thanks to [@osm0sis](https://github.com/osm0sis) for the `gen_pif_custom.sh` script on [xda](https://xdaforums.com/t/tools-zips-scripts-osm0sis-odds-and-ends-multiple-devices-platforms.2239421/post-89173470).
- Feel free to submit any issues [here](https://github.com/juleast/GeneratePIF/issues/new).
- Contact me on Telegram for any support [@Juleast](https://t.me/Juleast) (Just please do not spam)
- Support of the project with donations are welcome! [Buy me a coffee!](https://www.buymeacoffee.com/juleast)
