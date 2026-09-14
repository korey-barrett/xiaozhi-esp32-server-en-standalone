# esp32 Firmware Compilation

## Step 1: Prepare Your OTA Address

If you are using version 0.3.12 of this project, you will have an OTA address whether you use the simple Server deployment or the full-module deployment.

Because the OTA address is configured differently for the simple Server deployment and the full-module deployment, please choose the appropriate option below:

### If you use the simple Server deployment
Now open your OTA address in a browser, for example my OTA address
```
http://192.168.1.25:8003/xiaozhi/ota/
```
If it shows "OTA interface running normally, the websocket address sent to devices is: ws://xxx:8000/xiaozhi/v1/",

You can start the `digital-human` module, open `index.html` to test whether you can connect to the websocket address output by the OTA page.

If you cannot access it, you need to modify the `server.websocket` address in the `.config.yaml` configuration file, restart, and test again until `index.html` can be accessed normally.

After it succeeds, continue to Step 2.

### If you use the full-module deployment
Now open your OTA address in a browser, for example my OTA address
```
http://192.168.1.25:8002/xiaozhi/ota/
```

If it shows "OTA interface running normally, number of websocket clusters: X", then proceed to Step 2.

If it shows "OTA interface is not running normally", it is probably because you have not configured the `Websocket` address in the `Console`. Then:

- 1. Log in to the Console with a super administrator account

- 2. Click `Parameter Management` in the top menu

- 3. Find the `server.websocket` item in the list and enter your `Websocket` address. For example, mine is

```
ws://192.168.1.25:8000/xiaozhi/v1/
```

After configuring, refresh your OTA interface address in the browser and check whether it works now. If it still does not work, confirm again whether Websocket started normally and whether a Websocket address was configured.

> **Which OTA address should the firmware point at? (fork note)**
> This fork's standalone full-module stack runs **both** OTA endpoints, and both speak the device
> OTA protocol (returning `websocket`/`mqtt` + `firmware` config):
> - **`http://<LAN-IP>:8002/xiaozhi/ota/`** — the **console/Java** OTA (the address above and in
>   `README.md`). Fully managed from the Console: WebSocket/MQTT come from Parameter Management
>   (`server.websocket`, `server.mqtt_gateway`), and firmware is uploaded through the Console's
>   Firmware page (stored in the database; download link built from `server.ota`).
> - **`http://<LAN-IP>:8003/xiaozhi/ota/`** — the **Python server** OTA handler. It reads
>   `data/.config.yaml` (`server.websocket`, `server.mqtt_gateway`, `server.mqtt_signature_key`) and
>   serves firmware staged as `.bin` files in `data/bin/` — see
>   [ota-upgrade-guide.md](./ota-upgrade-guide.md).
>
> Pick the one that matches how you want to manage firmware (Console vs. files) and put it in the
> firmware's `OTA_URL` (Step 4). A full board-by-board flashing walkthrough is in
> [firmware-flash-guide.md](./firmware-flash-guide.md).

## Step 2: Configure the Environment
First, set up the project environment following the [official ESP-IDF Windows setup guide](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/get-started/windows-setup.html).

## Step 3: Open the Configuration File
After setting up the build environment, download the xiaozhi-esp32 project source code from Xiaoge,

Download Xiaoge's [xiaozhi-esp32 project source](https://github.com/78/xiaozhi-esp32).

After downloading, open the `xiaozhi-esp32/main/Kconfig.projbuild` file.

> **Choosing a board:** the board names in the Console's board dictionary (System → Dictionary →
> `FIRMWARE_TYPE`) are exactly the build names from `main/boards/**/config.json`
> (`type` / `builds[].name`). In menuconfig (Step 5), pick the board under `Xiaozhi Assistant →
> Target Board` that matches your physical hardware and your dictionary entry; its `config.json`
> `target` tells you which `idf.py set-target` chip to use.

## Step 4: Modify the OTA Address

Find the `default` content of `OTA_URL`, and change `https://api.tenclass.net/xiaozhi/ota/`
   to your own address. For example, if my interface address is `http://192.168.1.25:8002/xiaozhi/ota/`, change the content to that.

Before:
```
config OTA_URL
    string "Default OTA URL"
    default "https://api.tenclass.net/xiaozhi/ota/"
    help
        The application will access this URL to check for new firmwares and server address.
```
After:
```
config OTA_URL
    string "Default OTA URL"
    default "http://192.168.1.25:8002/xiaozhi/ota/"
    help
        The application will access this URL to check for new firmwares and server address.
```

## Step 4: Set the Build Parameters

Set the build parameters

```
# Enter the xiaozhi-esp32 root directory from the terminal command line
cd xiaozhi-esp32
# For example, my board is an esp32s3, so I set the build target to esp32s3; if your board is a different model, replace it with the corresponding model
idf.py set-target esp32s3
# Enter the menu configuration
idf.py menuconfig
```

After entering the menu configuration, go to `Xiaozhi Assistant` and set `BOARD_TYPE` to your board's specific model.
Save and exit, then return to the terminal command line.

## Step 5: Build the Firmware

```
idf.py build
```

## Step 6: Package the bin Firmware

```
cd scripts
python release.py
```

After the packaging command above completes, the firmware file `merged-binary.bin` will be generated in the `build` directory at the project root.
This `merged-binary.bin` is the firmware file to be flashed to the hardware.

Note: If a "zip"-related error is reported after running the second command, ignore it. As long as the firmware file `merged-binary.bin` is generated in the `build` directory, it has little impact on you. Please continue.

## Step 7: Flash the Firmware
   Connect the esp32 device to your computer, open the following URL with the Chrome browser

```
https://espressif.github.io/esp-launchpad/
```

Open the [ESP Launchpad web flashing tool](https://espressif.github.io/esp-launchpad/), select the precompiled firmware you built (e.g. `merged-binary.bin`), and flash it to the board in the browser — no IDF development environment needed.

After flashing succeeds and the device is connected to the network, wake Xiaozhi with the wake word and watch the console information output by the server.

## Frequently Asked Questions
Here are some common questions for reference:

[1. Why does Xiaozhi recognize so much Korean, Japanese, and English in what I say](./FAQ.md)

[2. Why does "TTS task error, file does not exist" occur](./FAQ.md)

[3. TTS often fails and often times out](./FAQ.md)

[4. I can connect to a self-hosted server over WiFi, but the 4G mode cannot connect](./FAQ.md)

[5. How can I improve Xiaozhi's conversation response speed](./FAQ.md)

[6. I speak slowly, and Xiaozhi keeps interrupting me during pauses](./FAQ.md)

[7. I want to control lights, air conditioners, remote power on/off, etc. through Xiaozhi](./FAQ.md)
