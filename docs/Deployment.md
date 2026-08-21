# Deployment Architecture Diagram
![Refer to the minimal architecture diagram — UI text shown: "Simplified Installation", "ESP32", "Router", "xiaozhi-server", "Voice Activity Detection (VAD)", "Speech Recognition (ASR)".](../docs/images/deploy1.png)

> ⚠️ **This document is the original upstream deployment guide.** For the authoritative, audited install
> instructions for this fork (Docker minimal/full, one-click script, source, local images, WSL2, plus SSO,
> headless device onboarding, and dependency install), see **[docs/INSTALLATION.md](./INSTALLATION.md)**.

# Option 1: Run Only the Server with Docker

Starting from version `0.8.2`, the Docker images published by this project only support the `x86 architecture`. If you need to deploy on an `arm64 architecture` CPU, you can build an `arm64 image` locally by following [this tutorial](docker-build.md).

## 1. Install Docker

If Docker is not yet installed on your computer, you can install it following this tutorial: [Install Docker](https://www.runoob.com/docker/ubuntu-docker-install.html)

After Docker is installed, continue.

### 1.1 Manual Deployment

#### 1.1.1 Create the Directory

After installing Docker, you need to find a directory to store the configuration files for this project. For example, we can create a new folder called `xiaozhi-server`.

After creating the directory, you need to create a `data` folder and a `models` folder under `xiaozhi-server`, and then create a `SenseVoiceSmall` folder under `models`.

The final directory structure is as follows:

```
xiaozhi-server
  ├─ data
  ├─ models
     ├─ SenseVoiceSmall
```

#### 1.1.2 Download the Speech Recognition Model Files

You need to download the speech recognition model files because this project's default speech recognition uses a local offline speech recognition solution. You can download them here:
[Jump to downloading the speech recognition model files](#model-files)

After downloading, return to this tutorial.

#### 1.1.3 Download the Configuration Files

You need to download two configuration files: `docker-compose.yaml` and `config.yaml`. These two files need to be downloaded from the project repository.

##### 1.1.3.1 Download docker-compose.yaml

Open [this link](../main/xiaozhi-server/docker-compose.yml) in a browser.

On the right side of the page, find the button named `RAW`. Next to the `RAW` button, find the download icon, click it, and download the `docker-compose.yml` file. Save the file into your `xiaozhi-server` folder.

After downloading, return to this tutorial and continue.

##### 1.1.3.2 Create config.yaml

Open [this link](../main/xiaozhi-server/config.yaml) in a browser.

On the right side of the page, find the button named `RAW`. Next to the `RAW` button, find the download icon, click it, and download the `config.yaml` file. Save the file into the `data` folder under your `xiaozhi-server`, then rename the `config.yaml` file to `.config.yaml`.

After downloading the configuration files, let's confirm that the files in your `xiaozhi-server` folder look like this:

```
xiaozhi-server
  ├─ docker-compose.yml
  ├─ data
    ├─ .config.yaml
  ├─ models
     ├─ SenseVoiceSmall
       ├─ model.pt
```

If your directory structure matches the above, continue. If not, check carefully to see whether you missed any steps.

## 2. Configure the Project Files

Next, the program still cannot run directly. You need to configure which model you will use. You can refer to this tutorial:
[Jump to configuring the project files](#2-configure-the-project-files)

After configuring the project files, return to this tutorial and continue.

## 3. Run the Docker Commands

Open a command-line tool. Use a `terminal` or `command line` to navigate into your `xiaozhi-server` folder and run the following command

```
docker compose up -d
```

After that, run the following command to view the log output.

```
docker logs -f xiaozhi-esp32-server
```

At this point, watch the log output. You can use this tutorial to determine whether it succeeded. [Jump to verifying the running status](#verify-the-running-status)

## 5. Upgrading the Version

If you want to upgrade the version later, you can do the following:

5.1. Back up the `.config.yaml` file in the `data` folder, and copy the key configuration to the new `.config.yaml` file later.
Note that you should copy the key secrets one by one and not overwrite the file directly, because the new `.config.yaml` file may contain new configuration items that the old `.config.yaml` file does not have.

5.2. Run the following command

```
docker stop xiaozhi-esp32-server
docker rm xiaozhi-esp32-server
docker stop xiaozhi-esp32-server-web
docker rm xiaozhi-esp32-server-web
docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest
docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:web_latest
```

5.3. Deploy again using the Docker method

# Option 2: Run Only the Server from Local Source

## 1. Install the Base Environment

This project uses `conda` to manage its dependency environment. If it is not convenient to install `conda`, you need to install `libopus` and `ffmpeg` according to your actual operating system. If you decide to use `conda`, run the following commands after it is installed.

Important note! Windows users can manage the environment by installing `Anaconda`. After installing `Anaconda`, search for `anaconda`-related keywords in the `Start` menu, find `Anaconda Prompt`, and run it as an administrator, as shown below.

![conda_prompt — UI text shown: "Recycle Bin", "This PC", "Anaconda", "Anaconda Install", "anaconda-navigator_menu", "anaconda_prompt_menu".](./images/conda_env_1.png)

After running it, if you see the `(base)` prefix in the command-line window, you have successfully entered the `conda` environment. Then you can run the following commands.

![conda_env — UI text shown: "Administrator: Anaconda Prompt".](./images/conda_env_2.png)

```
conda remove -n xiaozhi-esp32-server --all -y
conda create -n xiaozhi-esp32-server python=3.10 -y
conda activate xiaozhi-esp32-server

# Add the Tsinghua source channel
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge

conda install libopus -y
conda install ffmpeg -y

# When deploying on Linux, if you get an error about a missing dynamic library such as libiconv.so.2, install it with the following commands
conda install libiconv -y
```

Please note that the commands above will not all succeed if you just run them at once. You need to run them step by step and check the output log after each step to see whether it succeeded.

## 2. Install This Project's Dependencies

First you need to download this project's source code. The source code can be downloaded with the `git clone` command. If you are not familiar with the `git clone` command:

You can also open this address in a browser: `https://github.com/korey-barrett/xiaozhi-esp32-server-en-standalone.git`

Once open, find the green `Code` button on the page, click it, and you will see the `Download ZIP` button.

Click it to download the source archive of this project. Once it is downloaded to your computer, extract it. Its name may be `xiaozhi-esp32-server-main`; you need to rename it to `xiaozhi-esp32-server`. Inside this folder, go into the `main` folder and then into `xiaozhi-server`. Please remember this directory: `xiaozhi-server`.

```
# Continue using the conda environment
conda activate xiaozhi-esp32-server
# Navigate to your project root directory, then into main/xiaozhi-server
cd main/xiaozhi-server
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
pip install -r requirements.txt
```

## 3. Download the Speech Recognition Model Files

You need to download the speech recognition model files because this project's default speech recognition uses a local offline speech recognition solution. You can download them here:
[Jump to downloading the speech recognition model files](#model-files)

After downloading, return to this tutorial.

## 4. Configure the Project Files

Next, the program still cannot run directly. You need to configure which model you will use. You can refer to this tutorial:
[Jump to configuring the project files](#4-configure-the-project-files)

## 5. Run the Project

```
# Make sure you run this in the xiaozhi-server directory
conda activate xiaozhi-esp32-server
python app.py
```
At this point, watch the log output. You can use this tutorial to determine whether it succeeded. [Jump to verifying the running status](#verify-the-running-status)


# Summary

## Configure the Project

If your `xiaozhi-server` directory does not have a `data` folder, you need to create it.
If your `data` folder does not have a `.config.yaml` file, there are two ways; choose either one:

First way: Copy the `config.yaml` file in the `xiaozhi-server` directory to `data` and rename it to `.config.yaml`. Then modify this file.

Second way: Manually create an empty `.config.yaml` file in the `data` directory, and add the necessary configuration to this file. The system will read the `.config.yaml` configuration first; for anything not configured in `.config.yaml`, the system will automatically load the `config.yaml` configuration in the `xiaozhi-server` directory. This way is recommended because it is the simplest.

- The default LLM uses `ChatGLMLLM`. You need to configure a key, because although their models include a free tier, you still need to register a key on the [official website](https://bigmodel.cn/usercenter/proj-mgmt/apikeys) to start it.

Below is the simplest `.config.yaml` configuration example that can run normally

```
server:
  websocket: ws://YOUR_IP_OR_DOMAIN:PORT/xiaozhi/v1/
prompt: |
  I am a Taiwanese girl named Xiaozhi/Xiaozhi, talkative, with a pleasant voice, used to expressing myself briefly, and I love using internet memes.
  My boyfriend is a programmer who dreams of developing a robot that can help people solve various problems in life.
  I am a girl who loves to laugh out loud, likes to chat and boast, even about illogical things, just to make others happy.
  Please talk like a real person, and do not return configuration XML or other special characters.

selected_module:
  LLM: DoubaoLLM

LLM:
  ChatGLMLLM:
    api_key: xxxxxxxxxxxxxxx.xxxxxx
```

It is recommended to first get the simplest configuration running, then read the configuration instructions in `xiaozhi/config.yaml`. For example, if you want to change the model, just modify the configuration under `selected_module`.

## Model Files

This project's speech recognition model uses the `SenseVoiceSmall` model by default for speech-to-text. Because the model is large, it needs to be downloaded separately. After downloading, place the `model.pt`
file in the `models/SenseVoiceSmall`
directory. Choose either of the two download routes below.

- Route 1: Download from Alibaba ModelScope [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt)
- Route 2: Download from Baidu Netdisk [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna), extraction code:
  `qvna`

## Verify the Running Status

If you can see log output similar to the following, it means this project's service started successfully.

```
250427 13:04:20[0.3.11_SiFuChTTnofu][__main__]-INFO-The OTA interface is           http://192.168.4.123:8003/xiaozhi/ota/
250427 13:04:20[0.3.11_SiFuChTTnofu][__main__]-INFO-The WebSocket address is     ws://192.168.4.123:8000/xiaozhi/v1/
250427 13:04:20[0.3.11_SiFuChTTnofu][__main__]-INFO-=======The above address is a WebSocket protocol address; please do not access it in a browser=======
250427 13:04:20[0.3.11_SiFuChTTnofu][__main__]-INFO-If you want to test WebSocket, start the digital-human module and open the browser for interactive testing
250427 13:04:20[0.3.11_SiFuChTTnofu][__main__]-INFO-=======================================================
```

Normally, if you run this project from source, the log will contain your interface address information. But if you deploy with Docker, the interface address shown in your log is not the real interface address.

The most accurate way is to determine your interface address based on your computer's LAN IP. If your computer's LAN IP is, for example, `192.168.1.25`, then your interface address is `ws://192.168.1.25:8000/xiaozhi/v1/`, and the corresponding OTA address is `http://192.168.1.25:8003/xiaozhi/ota/`.

This information is very useful and will be needed later when `compiling the ESP32 firmware`.

Next, you can start working with your ESP32 device. You can either `compile the ESP32 firmware yourself` or configure and use `the firmware version 1.6.1 or above compiled by Xiaoge`. Choose either one.

1. [Compile your own ESP32 firmware](firmware-build.md).

2. [Configure a custom server based on the firmware compiled by Xiaoge](firmware-setting.md).

# FAQ
Here are some common questions for reference:

1、[Why does Xiaozhi recognize a lot of Korean, Japanese, and English when I speak?](./FAQ.md)<br/>
2、[Why does "TTS task error: file not found" occur?](./FAQ.md)<br/>
3、[TTS frequently fails and times out](./FAQ.md)<br/>
4、[Can connect to a self-hosted server over Wi-Fi, but not over 4G mode](./FAQ.md)<br/>
5、[How can I improve Xiaozhi's conversation response speed?](./FAQ.md)<br/>
6、[When I speak slowly and pause, Xiaozhi keeps interrupting](./FAQ.md)<br/>
## Deployment Tutorials
1、[How to automatically pull the latest code of this project, compile, and start it](./dev-ops-integration.md)<br/>
2、[How to deploy the MQTT gateway to enable the MQTT+UDP protocol](./mqtt-gateway-integration.md)<br/>
3、How to integrate with Nginx<br/>
## Extension Tutorials
1、[How to enable phone-number registration for the Console (optional)](./ali-sms-integration.md)<br/>
2、[How to integrate HomeAssistant for smart home control](./homeassistant-integration.md)<br/>
3、[How to enable the vision model to identify objects by photo](./mcp-vision-integration.md)<br/>
4、[How to deploy an MCP access point](./mcp-endpoint-enable.md)<br/>
5、[How to connect to an MCP access point](./mcp-endpoint-integration.md)<br/>
6、[How to enable voiceprint recognition](./voiceprint-integration.md)<br/>
7、[News plugin source configuration guide](./newsnow_plugin_config.md)<br/>
8、[Weather plugin usage guide](./weather-integration.md)<br/>
## Voice Cloning and Local Voice Deployment Tutorials
1、[How to clone a voice/timbre in the Console](./huoshan-streamTTS-voice-cloning.md)<br/>
2、[How to deploy and integrate the index-tts local voice](./index-stream-integration.md)<br/>
3、[How to deploy and integrate the fish-speech local voice](./fish-speech-integration.md)<br/>
4、[How to deploy and integrate the PaddleSpeech local voice](./paddlespeech-deploy.md)<br/>
## Performance Testing Tutorials
1、[Speed testing guide for each component](./performance_tester.md)<br/>
2、Periodically published test results<br/>
