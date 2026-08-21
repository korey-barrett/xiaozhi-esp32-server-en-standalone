# Device-to-Device Call Plugin Usage Guide

## Overview

The device call feature allows two configured devices to communicate bidirectionally through a voice/data channel. When device A calls device B, the system works through the following flow:

```
Device A → Authorization check → MQTT gateway → Remote wake-up of device B → Establish connection → Call established
```
## Prerequisites for Using This Feature
1. You must have at least two devices, and each device model must be `ESP32-S3`, because only `ESP32-S3` supports the remote wake-up feature.
2. Your device must have `two microphones`. However, if your device has only a `single microphone` and you just want to try out this feature, that is also possible, but you will experience noticeable lag.
3. You must deploy this project using [all-modules deployment](Deployment_all.md), because you need the `Console` to manage device permissions and communication.
4. You must install and configure an [MQTT gateway service](mqtt-gateway-integration.md) dated after `May 27, 2026`. If you have already deployed an MQTT gateway service, please confirm that the code version is from after `May 27, 2026`.

The above are the hard requirements for using this feature. Details are provided below.

## Configuration Steps

### Step 1: Enable the Address Book Feature

1. Confirm that your Console version is `0.9.4` or above.
2. Log in to the Console backend
3. Go to **System Feature Configuration**
4. Check **Address Book** in the left feature list
5. Click **Save Configuration** to confirm

### Step 2: Configure Device-to-Device Call Permissions

1. Click **Address Book** in the Console top menu
2. Under the agent on the left, select device A in the device list (supports searching by MAC address or remark name)
3. In the detail panel on the right, find the display name setting for target device B, e.g. **"Xiaowang"**
4. Check the **Call Permission** checkbox for device B
5. Click **Save**

**Bidirectional authorization:** For device A and device B to communicate with each other, you must configure each other's permissions on both Console sides. For example:

- In device A's configuration, check device B → device A can communicate with device B
- In device B's configuration, check device A → device B can communicate with device A

### Step 3: Add the Call Tool in the Agent Configuration

1. Click **Agent Management** in the Console top menu
2. In the agent related to the device contact you just configured, click **Edit Role**
3. In the detail panel on the right, click **Edit Features**
4. Check the **Device Calls Device** tool
5. Click **Save Configuration** to confirm
6. Click **Save Configuration** again on the outer side, then restart the device

### Step 4: Add the Remote Wake-up Tool on the Firmware Side

1. On top of the [xiaozhi-esp32](https://github.com/78/xiaozhi-esp32) code, add the remote wake-up MCP tool, supported versions 2.1.0 through 2.2.6 (the May 29, 2026 version)
2. Add the remote wake-up function declaration in the application.h file
    ```cpp
    void RemoteWakeup(const std::string& reason);
    ```
3. Add the remote wake-up function in the application.cc file
    ```cpp
    void Application::RemoteWakeup(const std::string& reason){
        if (!protocol_) {
            return;
        }

        auto state = GetDeviceState();
        
        if (state == kDeviceStateIdle) {
            audio_service_.EncodeWakeWord();

            if (!protocol_->IsAudioChannelOpened()) {
                SetDeviceState(kDeviceStateConnecting);
                if (!protocol_->OpenAudioChannel()) {
                    audio_service_.EnableWakeWordDetection(true);
                    return;
                }
            }
            std::string wake_word = reason;
    #if CONFIG_USE_AFE_WAKE_WORD || CONFIG_USE_CUSTOM_WAKE_WORD
            // Encode and send the wake word data to the server
            while (auto packet = audio_service_.PopWakeWordPacket()) {
                protocol_->SendAudio(std::move(packet));
            }
            // Set the chat state to wake word detected
            protocol_->SendWakeWordDetected(wake_word);
            SetListeningMode(aec_mode_ == kAecOff ? kListeningModeAutoStop : kListeningModeRealtime);
    #else
            // Set flag to play popup sound after state changes to listening
            // (PlaySound here would be cleared by ResetDecoder in EnableVoiceProcessing)
            play_popup_on_listening_ = true;
            SetListeningMode(aec_mode_ == kAecOff ? kListeningModeAutoStop : kListeningModeRealtime);
    #endif
        } else if (state == kDeviceStateSpeaking) {
            AbortSpeaking(kAbortReasonWakeWordDetected);
            SetDeviceState(kDeviceStateIdle);
        } else if (state == kDeviceStateActivating) {
            SetDeviceState(kDeviceStateIdle);
        }
    }
    ```
4. Add the remote wake-up tool in the mcp_server.cc file
    ```cpp
    AddUserOnlyTool("self.remote_wakeup", "Remote wakeup function with configurable parameters",
        PropertyList({
            Property("reason", kPropertyTypeString, "Wakeup reason"),
        }),
        [this](const PropertyList& properties) -> ReturnValue {
            std::string reason = properties["reason"].value<std::string>();
            ESP_LOGI(TAG, "Wakeup reason=%s", reason.c_str());
            auto& app = Application::GetInstance();
            app.RemoteWakeup(reason);
            return true;
    ```
5. Complete the firmware flashing following the [Firmware Compile and Flash Guide](firmware-build.md)
6. Regardless of whether your device has a single or dual microphone, enable the AEC feature in the compile step!
7. Regardless of whether your device has a single or dual microphone, enable the AEC feature in the compile step!
8. Regardless of whether your device has a single or dual microphone, enable the AEC feature in the compile step!

### Step 5: Configure the MQTT Gateway Service

1. Deploy the MQTT gateway service, referring to the [MQTT Gateway Integration Document](mqtt-gateway-integration.md)
2. If it is already deployed, confirm that the code version is from May 27, 2026

## Call Flow Description

Prepare two devices. After configuring the communication permissions in the Console and adding the call tool in the agent, say "Call XXX" to one of the Xiaozhi devices and observe whether device B responds.

## FAQ

### Q: Device B does not respond to the call?

- Check whether device B is online (device status in the Console)
- Confirm that device B's firmware has correctly integrated the remote wake-up tool
- Check whether the MQTT gateway connection is normal
- Verify that the bidirectional permission configuration is complete

### Q: It says "No call permission"?

- In the Console, confirm that device A has device B's call permission checked
- Confirm that the configuration has been saved (not merely modified without saving)

### Q: How do I confirm that the address book feature is enabled?

- If the "Address Book" entry is shown in the Console top menu, the feature is enabled

### Q: I asked it to call "Zhang Shan", but it always recognizes "Zhang San". What should I do?
- Refer to the documentation of the ASR service you are using to confirm whether it supports hotword recognition.
- If you are using `FunASRServer`, you can add "Zhang Shan" to the `hotword file` in the container and then restart the container.
- If you are using the `Volcano Engine` service, you can add a `hotword file` in the `Volcano Engine console`, then return to the Console's `Model Configuration page` and configure the `hotword file name` on `Volcano Engine's TTS`.

