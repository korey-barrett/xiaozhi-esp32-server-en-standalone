# ESP32 Firmware Compilation

## Step 1: Prepare Your OTA Address

If you are using version 0.3.12 or later of this project, whether it is a simple Server deployment or a full-module deployment, you will have an OTA address.

Since the OTA address configuration method differs between simple Server deployment and full-module deployment, choose the specific method below:

### If you are using simple Server deployment
At this point, open your OTA address in a browser. For example, my OTA address is
```
http://192.168.1.25:8003/xiaozhi/ota/
```
If it shows "OTA interface running normally, websocket address sent to the device is: ws://xxx:8000/xiaozhi/v1/

You can start the `digital-human` module, then open `index.html` to test whether you can connect to the websocket address output on the OTA page.

If you cannot access it, you need to modify the `server.websocket` address in the `.config.yaml` configuration file, restart, and test again until `index.html` can be accessed normally.

After success, proceed to Step 2.

### If you are using full-module deployment
At this point, open your OTA address in a browser. For example, my OTA address is
```
http://192.168.1.25:8002/xiaozhi/ota/
```

If it shows "OTA interface running normally, number of websocket clusters: X", then proceed to Step 2.

If it shows "OTA interface is not running normally", it is probably because you have not configured the `Websocket` address in the `console`. In that case:

- 1、Log in to the console as the super administrator

- 2、Click `Parameter Management` in the top menu

- 3、Find the `server.websocket` item in the list, and enter your `Websocket` address. For example, mine is

```
ws://192.168.1.25:8000/xiaozhi/v1/
```

After configuring it, refresh your OTA interface address in the browser and see whether it is normal now. If it is still not normal, confirm again whether Websocket has started normally and whether the Websocket address has been configured.

## Step 2: Configure the Environment
First, configure the project environment by following this tutorial: [《Set up the Windows ESP-IDF 5.3.2 development environment and compile Xiaozhi》](https://icnynnzcwou8.feishu.cn/wiki/JEYDwTTALi5s2zkGlFGcDiRknXf)

## Step 3: Open the Configuration File
After configuring the compilation environment, download the source code of Xiaoge's `xiaozhi-esp32` project.

Download Xiaoge's [xiaozhi-esp32 project source code](https://github.com/78/xiaozhi-esp32) from here.

After downloading, open the `xiaozhi-esp32/main/Kconfig.projbuild` file.

## Step 4: Modify the OTA Address

Find the `default` content of `OTA_URL`, and change `https://api.tenclass.net/xiaozhi/ota/`
to your own address. For example, my interface address is `http://192.168.1.25:8002/xiaozhi/ota/`, so I change the content to that.

Before modification:
```
config OTA_URL
    string "Default OTA URL"
    default "https://api.tenclass.net/xiaozhi/ota/"
    help
        The application will access this URL to check for new firmwares and server address.
```
After modification:
```
config OTA_URL
    string "Default OTA URL"
    default "http://192.168.1.25:8002/xiaozhi/ota/"
    help
        The application will access this URL to check for new firmwares and server address.
```

## Step 4: Set the Compilation Parameters

Set the compilation parameters

```
# Enter the root directory of xiaozhi-esp32 from the terminal command line
cd xiaozhi-esp32
# For example, my board is esp32s3, so I set the compilation target to esp32s3. If your board is another model, replace it with the corresponding model.
idf.py set-target esp32s3
# Enter menu configuration
idf.py menuconfig
```

After entering the menu configuration, enter `Xiaozhi Assistant` and set `BOARD_TYPE` to your board's specific model.
Save and exit, then return to the terminal command line.

## Step 5: Compile the Firmware

```
idf.py build
```

## Step 6: Package the bin Firmware

```
cd scripts
python release.py
```

After the packaging command above finishes, the firmware file `merged-binary.bin` will be generated in the `build` directory at the project root.
This `merged-binary.bin` is the firmware file to be flashed to the hardware.

Note: If the second command reports a "zip"-related error, ignore it. As long as the `build` directory generates the firmware file `merged-binary.bin`, it has no major impact on you. Continue.

## Step 7: Flash the Firmware
   Connect the esp32 device to your computer, and open the following address with the Chrome browser.

```
https://espressif.github.io/esp-launchpad/
```

Open this tutorial, [Flash tool / Flash firmware via web browser (without IDF development environment)](https://ccnphfhqs21z.feishu.cn/wiki/Zpz4wXBtdimBrLk25WdcXzxcnNS).
Skip to: `Method 2: ESP-Launchpad browser web flashing`, starting from `3. Flash the firmware / download to the development board`, and follow the tutorial steps.

After flashing succeeds and the device connects to the network, wake Xiaozhi with the wake word, and pay attention to the console information output by the server.

## Frequently Asked Questions
Here are some common questions for reference:

[1、Why does Xiaozhi recognize a lot of my speech as Korean, Japanese, or English?](./FAQ_en.md)

[2、Why does "TTS task error: file does not exist" appear?](./FAQ_en.md)

[3、TTS often fails and frequently times out](./FAQ_en.md)

[4、WiFi can connect to my self-built server, but 4G mode cannot](./FAQ_en.md)

[5、How do I improve Xiaozhi's conversation response speed?](./FAQ_en.md)

[6、I speak very slowly, and Xiaozhi always interrupts me during pauses](./FAQ_en.md)

[7、I want to control lights, air conditioners, remote power on/off, etc. through Xiaozhi](./FAQ_en.md)
