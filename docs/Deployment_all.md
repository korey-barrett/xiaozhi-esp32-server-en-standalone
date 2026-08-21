# Deployment Architecture Diagram
![Refer to the all-modules installation architecture diagram — UI text shown: "Visual Model (VLLM)", "Voice Activity Detection (VAD)", "Automatic Speech Recognition (ASR)", "Voice Print Recognition (VP)", "Large Language Model (LLM)", "Memory (MEM)".](../docs/images/deploy2.png)

> ⚠️ **This document is the original upstream deployment guide.** For the authoritative, audited install
> instructions for this fork (Docker minimal/full, one-click script, source, local images, WSL2, plus SSO,
> headless device onboarding, and dependency install), see **[docs/INSTALLATION.md](./INSTALLATION.md)**.

# Option 1: Run All Modules with Docker
Starting from version `0.8.2`, the Docker images published by this project only support the `x86 architecture`. If you need to deploy on an `arm64 architecture` CPU, you can build an `arm64 image` locally by following [this tutorial](docker-build.md).

## 1. Install Docker

If Docker is not yet installed on your computer, you can install it following this tutorial: [Install Docker](https://www.runoob.com/docker/ubuntu-docker-install.html)

There are two ways to install all modules with Docker. You can [use the lazy script](./Deployment_all.md#11-lazy-script) (by [@VanillaNahida](https://github.com/VanillaNahida)), which automatically downloads the required files and configuration files for you, or you can use [manual deployment](./Deployment_all.md#12-manual-deployment) to set everything up from scratch.



### 1.1 Lazy Script
Deployment is simple; you can refer to the [video tutorial](https://www.bilibili.com/video/BV17bbvzHExd/). The text version of the tutorial is as follows:
> [!NOTE]  
> Currently only one-click deployment on Ubuntu servers is supported; other systems have not been tested and may have some strange bugs

Use an SSH tool to connect to the server and run the following script with root privileges
```bash
> Note: The one-click setup script is not available in this fork. Use the files in this repository
> (`main/xiaozhi-server/docker-compose_all.yml` and `main/xiaozhi-server/config.yaml`) instead of
> downloading them from the original repository.
```

The script will automatically complete the following operations:
> 1. Install Docker
> 2. Configure the image source
> 3. Download/pull images
> 4. Download the speech recognition model files
> 5. Guide server configuration
>

After the script finishes and you do a simple configuration, refer to the 3 most important things mentioned in [4. Run the Program](#4-run-the-program) and [5. Restart xiaozhi-esp32-server](#5-restart-xiaozhi-esp32-server); after completing these three configurations, it is ready to use.

### 1.2 Manual Deployment

#### 1.2.1 Create the Directory

After installation, you need to find a directory to store the configuration files for this project. For example, we can create a new folder called `xiaozhi-server`.

After creating the directory, you need to create a `data` folder and a `models` folder under `xiaozhi-server`, and then create a `SenseVoiceSmall` folder under `models`.

The final directory structure is as follows:

```
xiaozhi-server
  ├─ data
  ├─ models
     ├─ SenseVoiceSmall
```

#### 1.2.2 Download the Speech Recognition Model Files

This project's speech recognition model uses the `SenseVoiceSmall` model by default for speech-to-text. Because the model is large, it needs to be downloaded separately. After downloading, place the `model.pt`
file in the `models/SenseVoiceSmall`
directory. Choose either of the two download routes below.

- Route 1: Download from Alibaba ModelScope [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt)
- Route 2: Download from Baidu Netdisk [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna), extraction code:
  `qvna`


#### 1.2.3 Download the Configuration Files

You need to download two configuration files: `docker-compose_all.yaml` and `config_from_api.yaml`. These two files need to be downloaded from the project repository.

##### 1.2.3.1 Download docker-compose_all.yaml

Open [this link](../main/xiaozhi-server/docker-compose_all.yml) in a browser.

On the right side of the page, find the button named `RAW`. Next to the `RAW` button, find the download icon, click it, and download the `docker-compose_all.yml` file. Save the file into your `xiaozhi-server` folder.

Or use the `docker-compose_all.yml` file from this repository (`main/xiaozhi-server/docker-compose_all.yml`) instead of downloading it from the original repository.

After downloading, return to this tutorial and continue.

##### 1.2.3.2 Download config_from_api.yaml

Open [this link](../main/xiaozhi-server/config_from_api.yaml) in a browser.

On the right side of the page, find the button named `RAW`. Next to the `RAW` button, find the download icon, click it, and download the `config_from_api.yaml` file. Save the file into the `data` folder under your `xiaozhi-server`, then rename the `config_from_api.yaml` file to `.config.yaml`.

Or use the `config_from_api.yaml` file from this repository (`main/xiaozhi-server/config_from_api.yaml`) instead of downloading it from the original repository.

After downloading the configuration files, let's confirm that the files in your `xiaozhi-server` folder look like this:

```
xiaozhi-server
  ├─ docker-compose_all.yml
  ├─ data
    ├─ .config.yaml
  ├─ models
     ├─ SenseVoiceSmall
       ├─ model.pt
```

If your directory structure matches the above, continue. If not, check carefully to see whether you missed any steps.

## 2. Back Up Data

If you have previously run the Console successfully and have key information saved on it, please copy the important data from the Console first, because the original data may be overwritten during the upgrade process.

## 3. Remove Old-version Images and Containers
Next, open a command-line tool. Use a `terminal` or `command line` to navigate into your `xiaozhi-server` folder and run the following commands

```
docker compose -f docker-compose_all.yml down

docker stop xiaozhi-esp32-server
docker rm xiaozhi-esp32-server

docker stop xiaozhi-esp32-server-web
docker rm xiaozhi-esp32-server-web

docker stop xiaozhi-esp32-server-db
docker rm xiaozhi-esp32-server-db

docker stop xiaozhi-esp32-server-redis
docker rm xiaozhi-esp32-server-redis

docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest
docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:web_latest
```

## 4. Run the Program
Run the following command to start the new-version container

```
docker compose -f docker-compose_all.yml up -d
```

After that, run the following command to view the log output.

```
docker logs -f xiaozhi-esp32-server-web
```

When you see the output log, it means your `Console` started successfully.

```
2025-xx-xx 22:11:12.445 [main] INFO  c.a.d.s.b.a.DruidDataSourceAutoConfigure - Init DruidDataSource
2025-xx-xx 21:28:53.873 [main] INFO  xiaozhi.AdminApplication - Started AdminApplication in 16.057 seconds (process running for 17.941)
http://localhost:8002/xiaozhi/doc.html
```

Note that at this point only the `Console` is running. If the `xiaozhi-esp32-server` on port 8000 reports errors, ignore them for now.

At this point, use a browser to open the `Console` at http://127.0.0.1:8002 and register the first user. The first user is the super administrator; subsequent users are ordinary users. Ordinary users can only bind devices and configure agents; the super administrator can perform model management, user management, parameter configuration, and other functions.

Next, there are three important things to do:

### The First Important Thing

Using the super administrator account, log in to the Console, find `Parameter Management` in the top menu, find the first item in the list whose parameter code is `server.secret`, and copy it to `Parameter Value`.

A note about `server.secret`: this `Parameter Value` is very important because it lets our `Server` connect to `manager-api`. `server.secret` is a key that is automatically generated randomly each time the manager module is deployed from scratch.

After copying the `Parameter Value`, open the `.config.yaml` file in the `data` directory under `xiaozhi-server`. At this point your configuration file should look like this:

```
manager-api:
  url:  http://127.0.0.1:8002/xiaozhi
  secret: YOUR_server.secret_value
```
1. Copy the `Parameter Value` of `server.secret` that you just copied from the `Console` into `secret` in the `.config.yaml` file.

2. Because you are deploying with Docker, change `url` to `http://xiaozhi-esp32-server-web:8002/xiaozhi` below

3. Because you are deploying with Docker, change `url` to `http://xiaozhi-esp32-server-web:8002/xiaozhi` below

4. Because you are deploying with Docker, change `url` to `http://xiaozhi-esp32-server-web:8002/xiaozhi` below

Like this:
```
manager-api:
  url: http://xiaozhi-esp32-server-web:8002/xiaozhi
  secret: 12345678-xxxx-xxxx-xxxx-123456789000
```

After saving, continue to the second important thing.

### The Second Important Thing

Using the super administrator account, log in to the Console, find `Model Configuration` in the top menu, then click `Large Language Model` in the left sidebar, find the first item `Zhipu AI`, and click the `Edit` button.
After the edit dialog appears, fill in the key you registered with `Zhipu AI` in `API Key`, then click Save.

## 5. Restart xiaozhi-esp32-server

Next, open a command-line tool. Use a `terminal` or `command line` and type
```
docker restart xiaozhi-esp32-server
docker logs -f xiaozhi-esp32-server
```
If you can see log output similar to the following, it means the Server started successfully.

```
25-02-23 12:01:09[core.websocket_server] - INFO - The WebSocket address is      ws://xxx.xx.xx.xx:8000/xiaozhi/v1/
25-02-23 12:01:09[core.websocket_server] - INFO - =======The above address is a WebSocket protocol address; please do not access it in a browser=======
25-02-23 12:01:09[core.websocket_server] - INFO - If you want to test WebSocket, start the digital-human module and open the browser for interactive testing
25-02-23 12:01:09[core.websocket_server] - INFO - =======================================================
```

Since you are using the all-modules deployment, you have two important interfaces that need to be written into the ESP32.

OTA interface:
```
http://YOUR_HOST_LAN_IP:8002/xiaozhi/ota/
```

WebSocket interface:
```
ws://YOUR_HOST_IP:8000/xiaozhi/v1/
```

### The Third Important Thing

Using the super administrator account, log in to the Console, find `Parameter Management` in the top menu, find the parameter code `server.websocket`, and enter your `WebSocket interface`.

Using the super administrator account, log in to the Console, find `Parameter Management` in the top menu, find the parameter code `server.ota`, and enter your `OTA interface`.

Next, you can start working with your ESP32 device. You can either `compile the ESP32 firmware yourself` or configure and use `the firmware version 1.6.1 or above compiled by Xiaoge`. Choose either one.

1. [Compile your own ESP32 firmware](firmware-build.md).

2. [Configure a custom server based on the firmware compiled by Xiaoge](firmware-setting.md).


# Option 2: Run All Modules from Local Source

## 1. Install the MySQL Database

If MySQL is already installed on this machine, you can directly create a database named `xiaozhi_esp32_server`.

```sql
CREATE DATABASE xiaozhi_esp32_server CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

If you do not have MySQL yet, you can install it with Docker

```
docker run --name xiaozhi-esp32-server-db -e MYSQL_ROOT_PASSWORD=123456 -p 3306:3306 -e MYSQL_DATABASE=xiaozhi_esp32_server -e MYSQL_INITDB_ARGS="--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci" -e TZ=Asia/Shanghai -d mysql:latest
```

## 2. Install Redis

If you do not have Redis yet, you can install it with Docker

```
docker run --name xiaozhi-esp32-server-redis -d -p 6379:6379 redis
```

## 3. Run the manager-api Program

3.1 Install JDK 21 and set the JDK environment variables

3.2 Install Maven and set the Maven environment variables

3.3 Use the VSCode editor and install the relevant Java environment plugins

3.4 Use the VSCode editor to load the manager-api module

Configure the database connection information in `src/main/resources/application-dev.yml`

```
spring:
  datasource:
    username: root
    password: 123456
```
Configure the Redis connection information in `src/main/resources/application-dev.yml`
```
spring:
    data:
      redis:
        host: localhost
        port: 6379
        password:
        database: 0
```

3.5 Run the Main Program

This project is a Spring Boot project. To start it:
open `Application.java` and run the `Main` method

```
Path:
src/main/java/xiaozhi/AdminApplication.java
```

When you see the output log, it means your `manager-api` started successfully.

```
2025-xx-xx 22:11:12.445 [main] INFO  c.a.d.s.b.a.DruidDataSourceAutoConfigure - Init DruidDataSource
2025-xx-xx 21:28:53.873 [main] INFO  xiaozhi.AdminApplication - Started AdminApplication in 16.057 seconds (process running for 17.941)
http://localhost:8002/xiaozhi/doc.html
```

## 4. Run the manager-web Program

4.1 Install Node.js

4.2 Use the VSCode editor to load the manager-web module

In a terminal, navigate to the manager-web directory

```
npm install
```
Then start it
```
npm run serve
```

Note that if your manager-api interface is not at `http://localhost:8002`, modify the path in `main/manager-web/.env.development` during development.

After it runs successfully, use a browser to open the `Console` at http://127.0.0.1:8001 and register the first user. The first user is the super administrator; subsequent users are ordinary users. Ordinary users can only bind devices and configure agents; the super administrator can perform model management, user management, parameter configuration, and other functions.


Important: After registering, use the super administrator account to log in to the Console, find `Model Configuration` in the top menu, then click `Large Language Model` in the left sidebar, find the first item `Zhipu AI`, and click the `Edit` button.
After the edit dialog appears, fill in the key you registered with `Zhipu AI` in `API Key`, then click Save.

Important: After registering, use the super administrator account to log in to the Console, find `Model Configuration` in the top menu, then click `Large Language Model` in the left sidebar, find the first item `Zhipu AI`, and click the `Edit` button.
After the edit dialog appears, fill in the key you registered with `Zhipu AI` in `API Key`, then click Save.

Important: After registering, use the super administrator account to log in to the Console, find `Model Configuration` in the top menu, then click `Large Language Model` in the left sidebar, find the first item `Zhipu AI`, and click the `Edit` button.
After the edit dialog appears, fill in the key you registered with `Zhipu AI` in `API Key`, then click Save.

## 5. Install the Python Environment

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

## 6. Install This Project's Dependencies

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

### 7. Download the Speech Recognition Model Files

This project's speech recognition model uses the `SenseVoiceSmall` model by default for speech-to-text. Because the model is large, it needs to be downloaded separately. After downloading, place the `model.pt`
file in the `models/SenseVoiceSmall`
directory. Choose either of the two download routes below.

- Route 1: Download from Alibaba ModelScope [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt)
- Route 2: Download from Baidu Netdisk [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna), extraction code:
  `qvna`

## 8. Configure the Project Files

Using the super administrator account, log in to the Console, find `Parameter Management` in the top menu, find the first item in the list whose parameter code is `server.secret`, and copy it to `Parameter Value`.

A note about `server.secret`: this `Parameter Value` is very important because it lets our `Server` connect to `manager-api`. `server.secret` is a key that is automatically generated randomly each time the manager module is deployed from scratch.

If your `xiaozhi-server` directory does not have a `data` folder, you need to create it.
If your `data` folder does not have a `.config.yaml` file, you can copy the `config_from_api.yaml` file in the `xiaozhi-server` directory to `data` and rename it to `.config.yaml`

After copying the `Parameter Value`, open the `.config.yaml` file in the `data` directory under `xiaozhi-server`. At this point your configuration file should look like this:

```
manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: YOUR_server.secret_value
```

Copy the `Parameter Value` of `server.secret` that you just copied from the `Console` into `secret` in the `.config.yaml` file.

Like this:
```
manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: 12345678-xxxx-xxxx-xxxx-123456789000
```

## 9. Run the Project

```
# Make sure you run this in the xiaozhi-server directory
conda activate xiaozhi-esp32-server
python app.py
```

If you can see log output similar to the following, it means this project's service started successfully.

```
25-02-23 12:01:09[core.websocket_server] - INFO - Server is running at ws://xxx.xx.xx.xx:8000/xiaozhi/v1/
25-02-23 12:01:09[core.websocket_server] - INFO - =======The above address is a WebSocket protocol address; please do not access it in a browser=======
25-02-23 12:01:09[core.websocket_server] - INFO - If you want to test WebSocket, start the digital-human module and open the browser for interactive testing
25-02-23 12:01:09[core.websocket_server] - INFO - =======================================================
```

Since you are using the all-modules deployment, you have two important interfaces.

OTA interface:
```
http://YOUR_PC_LAN_IP:8002/xiaozhi/ota/
```

WebSocket interface:
```
ws://YOUR_PC_IP:8000/xiaozhi/v1/
```

Be sure to write the above two interface addresses into the Console: they will affect WebSocket address distribution and the automatic upgrade feature.

1. Using the super administrator account, log in to the Console, find `Parameter Management` in the top menu, find the parameter code `server.websocket`, and enter your `WebSocket interface`.

2. Using the super administrator account, log in to the Console, find `Parameter Management` in the top menu, find the parameter code `server.ota`, and enter your `OTA interface`.


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
