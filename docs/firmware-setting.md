# Configuring a custom server based on the firmware compiled by Xia Ge

## Step 1: Confirm the version
Flash the [firmware version 1.6.1 or later](https://github.com/78/xiaozhi-esp32/releases) already compiled by Xia Ge.

## Step 2: Prepare your OTA address
If you used full-module deployment following the tutorial, you should have an OTA address.

Now, open your OTA address in a browser, for example my OTA address is
```
https://2662r3426b.vicp.fun/xiaozhi/ota/
```

If it shows "OTA interface running normally, number of websocket clusters: X", continue below.

If it shows "OTA interface is not running normally", you probably have not configured the `Websocket` address in the `Console` yet. In that case:

- 1. Log in to the Console as super administrator.

- 2. Click `Parameter Management` in the top menu.

- 3. Find the `server.websocket` entry in the list and enter your `Websocket` address. For example, mine is:

```
wss://2662r3426b.vicp.fun/xiaozhi/v1/
```

After configuring it, refresh your OTA interface address in the browser to see whether it works normally now. If it still does not work, double-check whether Websocket started normally and whether the Websocket address is configured.

## Step 3: Enter pairing/network-configuration mode
Enter the device's network configuration mode, click "Advanced Options" at the top of the page, enter your server's `ota` address there, and click Save. Restart the device.
![Please refer to - OTA address setting — UI text shown: "Login", "Cancel", "Wi-Fi Configuration", "Advanced Options", "Custom OTA Address:", "http://192.168.1.25:8002/xiaozhi/ota/".](../docs/images/firmware-setting-ota.png)

## Step 4: Wake up Xiaozhi and check the log output

Wake up Xiaozhi and check whether the logs are output normally.

## FAQ
The following are some frequently asked questions for reference:

[1. Why does Xiaozhi recognize a lot of Korean, Japanese, and English in what I say?](./FAQ.md)

[2. Why does "TTS task error, file does not exist" appear?](./FAQ.md)

[3. TTS frequently fails and frequently times out](./FAQ.md)

[4. Wifi can connect to the self-hosted server, but 4G mode cannot connect](./FAQ.md)

[5. How can I improve Xiaozhi's conversation response speed?](./FAQ.md)

[6. I speak very slowly, and Xiaozhi keeps interrupting during pauses](./FAQ.md)

[7. I want to control lights, air conditioners, remote power on/off, etc. through Xiaozhi](./FAQ.md)
