# Deployment Architecture Diagram
![Full-module installation architecture diagram — UI text shown: "Visual Model (VLLM)", "Voice Activity Detection (VAD)", "Automatic Speech Recognition (ASR)", "Voice Print Recognition (VP)", "Large Language Model (LLM)", "Memory (MEM)".](../docs/images/deploy2.png)
# Method 1: Run the Full Modules with Docker
Since version `0.8.2`, the Docker images published by this project only support the `x86 architecture`. If you need to deploy on an `arm64` CPU, you can build an `arm64 image` locally by following [this tutorial](docker-build.md).

## 1. Install Docker

If Docker is not yet installed on your computer, follow the tutorial here: [Install Docker](https://www.runoob.com/docker/ubuntu-docker-install.html)

There are two ways to install the full modules with Docker. You can use the [lazy script](./Deployment_all.md#11-lazy-script) (author [@VanillaNahida](https://github.com/VanillaNahida))  
The script will automatically download the needed files and configuration files for you. You can also use [manual deployment](./Deployment_all.md#12-manual-deployment) to build everything from scratch.

### 1.1 Lazy Script
Deployment is simple. You can refer to the [video tutorial](https://www.bilibili.com/video/BV17bbvzHExd/). The text tutorial is as follows:
> [!NOTE]  
> For now, only Ubuntu-server one-click deployment is supported. Other systems have not been tested and may have some strange bugs.

Use an SSH tool to connect to the server, and run the following script as root:
```bash
sudo bash -c "$(wget -qO- https://ghfast.top/https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/main/docker-setup.sh)"
```

The script will automatically complete the following operations:
> 1. Install Docker
> 2. Configure the image source
> 3. Download/pull images
> 4. Download the speech recognition model file
> 5. Guide you through configuring the server
>

After it finishes, do some simple configuration, then refer to the three most important things mentioned in [4. Run the program](#4-run-the-program) and [5. Restart xiaozhi-esp32-server](#5-restart-xiaozhi-esp32-server). Complete these three configurations and it will be ready to use.

### 1.2 Manual Deployment

#### 1.2.1 Create Directories

After installation, you need to create a directory to hold this project's configuration files. For example, we can create a folder named `xiaozhi-server`.

After creating the directory, create a `data` folder and a `models` folder inside `xiaozhi-server`. Inside `models`, create another folder named `SenseVoiceSmall`.

The final directory structure looks like this:

```
xiaozhi-server
  ├─ data
  ├─ models
     ├─ SenseVoiceSmall
```

#### 1.2.2 Download the Speech Recognition Model File

This project's speech recognition model defaults to using the `SenseVoiceSmall` model to convert speech to text. Because the model is large, it must be downloaded separately. After downloading, place the `model.pt`
file in the `models/SenseVoiceSmall`
directory. Choose one of the two download routes below.

- Route 1: Download [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt) from Alibaba ModelScope
- Route 2: Download [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna) from Baidu Netdisk. Extraction code:
  `qvna`

#### 1.2.3 Download the Configuration Files

You need to download two configuration files: `docker-compose_all.yaml` and `config_from_api.yaml`. Both must be downloaded from the project repository.

##### 1.2.3.1 Download docker-compose_all.yaml

Open [this link](../main/xiaozhi-server/docker-compose_all.yml) in a browser.

On the right side of the page, find the button named `RAW`. Next to the `RAW` button, find the download icon, click the download button to download the `docker-compose_all.yml` file. Save the file into your `xiaozhi-server` directory.

Or directly run `wget https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/refs/heads/main/main/xiaozhi-server/docker-compose_all.yml` to download it.

After downloading, come back to this tutorial and continue.

##### 1.2.3.2 Download config_from_api.yaml

Open [this link](../main/xiaozhi-server/config_from_api.yaml) in a browser.

On the right side of the page, find the button named `RAW`. Next to the `RAW` button, find the download icon, click the download button to download the `config_from_api.yaml` file. Save the file into the `data` folder inside your `xiaozhi-server`, then rename `config_from_api.yaml` to `.config.yaml`.

Or directly run `wget https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/refs/heads/main/main/xiaozhi-server/config_from_api.yaml` to download and save it.

After downloading the configuration file, confirm the entire contents of `xiaozhi-server` look like this:

```
xiaozhi-server
  ├─ docker-compose_all.yml
  ├─ data
    ├─ .config.yaml
  ├─ models
     ├─ SenseVoiceSmall
       ├─ model.pt
```

If your directory structure matches the above, continue. If not, check carefully to see whether you missed a step.

## 2. Back Up Data

If you previously ran the console successfully, and it holds your secret/API-key information, first copy the important data down from the console. This is because the upgrade process may overwrite the original data.

## 3. Remove the Old Image and Container
Next, open a command-line tool. Use a `terminal` or `command-line` tool to enter your `xiaozhi-server` directory, then run the following command

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
Run the following command to start the new-version containers.

```
docker compose -f docker-compose_all.yml up -d
```

After it finishes, run the following command to view the log information.

```
docker logs -f xiaozhi-esp32-server-web
```

When you see output logs, it means your `console` started successfully.

```
2025-xx-xx 22:11:12.445 [main] INFO  c.a.d.s.b.a.DruidDataSourceAutoConfigure - Init DruidDataSource
2025-xx-xx 21:28:53.873 [main] INFO  xiaozhi.AdminApplication - Started AdminApplication in 16.057 seconds (process running for 17.941)
http://localhost:8002/xiaozhi/doc.html
```

Please note that at this point only the `console` is running. If `xiaozhi-esp32-server` on port 8000 reports an error, ignore it for now.

At this point, you need to open the `console` in a browser at: http://127.0.0.1:8002 , and register the first user. The first user is the super administrator; all later users are normal users. Normal users can only bind devices and configure agents; the super administrator can perform model management, user management, parameter configuration, and other functions.

Next, there are three important things to do:

### The First Important Thing

Using the super administrator account, log in to the console. In the top menu find `Parameter Management`, find the first item in the list with parameter code `server.secret`, and copy it into `Parameter Value`.

A note about `server.secret`: this `parameter value` is very important — its purpose is to let our `Server` connect to `manager-api`. `server.secret` is a secret that is automatically randomly generated each time the manager module is deployed from scratch.

After copying the `parameter value`, open the `.config.yaml` file in the `data` directory under `xiaozhi-server`. At this point your configuration file content should look like this:

```
manager-api:
  url:  http://127.0.0.1:8002/xiaozhi
  secret: your-server.secret-value
```
1、Copy the `parameter value` of `server.secret` that you copied from the `console` into the `secret` field in the `.config.yaml` file.

2、Because you are deploying with Docker, change the `url` to `http://xiaozhi-esp32-server-web:8002/xiaozhi`

3、Because you are deploying with Docker, change the `url` to `http://xiaozhi-esp32-server-web:8002/xiaozhi`

4、Because you are deploying with Docker, change the `url` to `http://xiaozhi-esp32-server-web:8002/xiaozhi`

It should look something like this
```
manager-api:
  url: http://xiaozhi-esp32-server-web:8002/xiaozhi
  secret: 12345678-xxxx-xxxx-xxxx-123456789000
```

After saving, continue to the second important thing.

### The Second Important Thing

Using the super administrator account, log in to the console. In the top menu find `Model Configuration`, then click `Large Language Model` in the left sidebar, find the first item `ZhipuAI`, click the `Modify` button,
and after the modification dialog pops up, enter the `API key` you registered for `ZhipuAI` into the `API Key` field. Then click Save.

## 5. Restart xiaozhi-esp32-server

Next, open a command-line tool. Use a `terminal` or `command-line` tool and enter
```
docker restart xiaozhi-esp32-server
docker logs -f xiaozhi-esp32-server
```
If you can see logs similar to the following, it is a sign that the Server started successfully.

```
25-02-23 12:01:09[core.websocket_server] - INFO - Websocket address is ws://xxx.xx.xx.xx:8000/xiaozhi/v1/
25-02-23 12:01:09[core.websocket_server] - INFO - =======The above address is a websocket protocol address, please do not visit it with a browser=======
25-02-23 12:01:09[core.websocket_server] - INFO - If you want to test websocket, start the digital-human module and open the browser for interactive testing
25-02-23 12:01:09[core.websocket_server] - INFO - =======================================================
```

Because you are using full-module deployment, you have two important interfaces that must be written into the esp32.

OTA interface:
```
http://your-host-LAN-ip:8002/xiaozhi/ota/
```

Websocket interface:
```
ws://your-host-ip:8000/xiaozhi/v1/
```

### The Third Important Thing

Using the super administrator account, log in to the console. In the top menu find `Parameter Management`, find the parameter with code `server.websocket`, and enter your `Websocket interface`.

Using the super administrator account, log in to the console. In the top menu find `Parameter Management`, find the parameter with code `server.ota`, and enter your `OTA interface`.

Next, you can start operating your esp32 device. You can either `compile the esp32 firmware yourself` or configure it to use the `firmware version 1.6.1 and above compiled by Xiaoge`. Choose either one.

1. [Compile your own esp32 firmware](firmware-build_en.md).

2. [Configure a custom server based on the firmware compiled by Xiaoge](firmware-setting_en.md).

# Method 2: Run the Full Modules from Local Source Code

## 1. Install the MySQL Database

If MySQL is already installed on this machine, you can directly create a database named `xiaozhi_esp32_server`.

```sql
CREATE DATABASE xiaozhi_esp32_server CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

If you do not have MySQL yet, you can install mysql via Docker.

```
docker run --name xiaozhi-esp32-server-db -e MYSQL_ROOT_PASSWORD=123456 -p 3306:3306 -e MYSQL_DATABASE=xiaozhi_esp32_server -e MYSQL_INITDB_ARGS="--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci" -e TZ=Asia/Shanghai -d mysql:latest
```

## 2. Install Redis

If you do not have Redis yet, you can install Redis via Docker.

```
docker run --name xiaozhi-esp32-server-redis -d -p 6379:6379 redis
```

## 3. Run the manager-api Program

3.1 Install JDK21, and set the JDK environment variables.

3.2 Install Maven, and set the Maven environment variables.

3.3 Use the Vscode editor, and install the relevant Java environment plugins.

3.4 Use the Vscode editor to load the manager-api module.

Configure the database connection information in `src/main/resources/application-dev.yml`.

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

3.5 Run the main program

This project is a SpringBoot project. The startup method is:
Open `Application.java` and run the `Main` method to start.

```
Path:
src/main/java/xiaozhi/AdminApplication.java
```

When you see output logs, it means your `manager-api` started successfully.

```
2025-xx-xx 22:11:12.445 [main] INFO  c.a.d.s.b.a.DruidDataSourceAutoConfigure - Init DruidDataSource
2025-xx-xx 21:28:53.873 [main] INFO  xiaozhi.AdminApplication - Started AdminApplication in 16.057 seconds (process running for 17.941)
http://localhost:8002/xiaozhi/doc.html
```

## 4. Run the manager-web Program

4.1 Install Node.js

4.2 Use the Vscode editor to load the manager-web module.

Enter the manager-web directory from the terminal command line.

```
npm install
```
Then start it.
```
npm run serve
```

Please note: if your manager-api interface is not at `http://localhost:8002`, modify the path in `main/manager-web/.env.development` during development.

After running successfully, you need to open the `console` in a browser at: http://127.0.0.1:8001 , and register the first user. The first user is the super administrator; all later users are normal users. Normal users can only bind devices and configure agents; the super administrator can perform model management, user management, parameter configuration, and other functions.

Important: After registering, using the super administrator account, log in to the console. In the top menu find `Model Configuration`, then click `Large Language Model` in the left sidebar, find the first item `ZhipuAI`, click the `Modify` button,
and after the modification dialog pops up, enter the `API key` you registered for `ZhipuAI` into the `API Key` field. Then click Save.

Important: After registering, using the super administrator account, log in to the console. In the top menu find `Model Configuration`, then click `Large Language Model` in the left sidebar, find the first item `ZhipuAI`, click the `Modify` button,
and after the modification dialog pops up, enter the `API key` you registered for `ZhipuAI` into the `API Key` field. Then click Save.

Important: After registering, using the super administrator account, log in to the console. In the top menu find `Model Configuration`, then click `Large Language Model` in the left sidebar, find the first item `ZhipuAI`, click the `Modify` button,
and after the modification dialog pops up, enter the `API key` you registered for `ZhipuAI` into the `API Key` field. Then click Save.

## 5. Install the Python Environment

This project uses `conda` to manage its dependency environment. If it is inconvenient to install `conda`, you must install `libopus` and `ffmpeg` according to your actual operating system.
If you decide to use `conda`, after installing it, run the following commands.

Important note! Windows users can manage the environment by installing `Anaconda`. After installing `Anaconda`, search for `anaconda`-related keywords in the `Start` menu,
find `Anaconda Prompt`, and run it as administrator. As shown below.

![conda_prompt — UI text shown: "Recycle Bin", "This PC", "Anaconda", "Anaconda Install", "anaconda-navigator_menu", "anaconda_prompt_menu".](./images/conda_env_1.png)

After running it, if you can see the `(base)` prefix in front of the command-line prompt, it means you have successfully entered the `conda` environment. Then you can run the following commands.

![conda_env — UI text shown: "Administrator: Anaconda Prompt".](./images/conda_env_2.png)

```
conda remove -n xiaozhi-esp32-server --all -y
conda create -n xiaozhi-esp32-server python=3.10 -y
conda activate xiaozhi-esp32-server

# Add the Tsinghua mirror channels
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge

conda install libopus -y
conda install ffmpeg -y

# When deploying on Linux, if you get an error similar to "missing libiconv.so.2 dynamic library", install it with the following command
conda install libiconv -y
```

Please note that the above commands will not all succeed if run at once. Execute them step by step, and after each step, check the output logs to see whether it succeeded.

## 6. Install This Project's Dependencies

First you need to download this project's source code. You can download it with the `git clone` command. If you are not familiar with the `git clone` command,

You can open this address in a browser `https://github.com/xinnan-tech/xiaozhi-esp32-server.git`

After opening it, find a green button labeled `Code` on the page, click it, and then you will see a `Download ZIP` button.

Click it to download this project's source archive. After downloading it to your computer, extract it. At this point its name may be `xiaozhi-esp32-server-main`.
You need to rename it to `xiaozhi-esp32-server`. Inside this folder, enter the `main` folder, then enter `xiaozhi-server`. Remember this directory: `xiaozhi-server`.

```
# Continue using the conda environment
conda activate xiaozhi-esp32-server
# Enter your project root directory, then enter main/xiaozhi-server
cd main/xiaozhi-server
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
pip install -r requirements.txt
```

### 7. Download the Speech Recognition Model File

This project's speech recognition model defaults to using the `SenseVoiceSmall` model to convert speech to text. Because the model is large, it must be downloaded separately. After downloading, place the `model.pt`
file in the `models/SenseVoiceSmall`
directory. Choose one of the two download routes below.

- Route 1: Download [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt) from Alibaba ModelScope
- Route 2: Download [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna) from Baidu Netdisk. Extraction code:
  `qvna`

## 8. Configure the Project Files

Using the super administrator account, log in to the console. In the top menu find `Parameter Management`, find the first item in the list with parameter code `server.secret`, and copy it into `Parameter Value`.

A note about `server.secret`: this `parameter value` is very important — its purpose is to let our `Server` connect to `manager-api`. `server.secret` is a secret that is automatically randomly generated each time the manager module is deployed from scratch.

If your `xiaozhi-server` directory has no `data` folder, you need to create a `data` directory.
If there is no `.config.yaml` file under `data`, you can copy the `config_from_api.yaml` file from the `xiaozhi-server` directory to `data`, and rename it to `.config.yaml`.

After copying the `parameter value`, open the `.config.yaml` file in the `data` directory under `xiaozhi-server`. At this point your configuration file content should look like this:

```
manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: your-server.secret-value
```

Copy the `parameter value` of `server.secret` that you copied from the `console` into the `secret` field in the `.config.yaml` file.

It should look something like this
```
manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: 12345678-xxxx-xxxx-xxxx-123456789000
```

## 9. Run the Project

```
# Make sure you are in the xiaozhi-server directory
conda activate xiaozhi-esp32-server
python app.py
```

If you can see logs similar to the following, it is a sign that this project's service started successfully.

```
25-02-23 12:01:09[core.websocket_server] - INFO - Server is running at ws://xxx.xx.xx.xx:8000/xiaozhi/v1/
25-02-23 12:01:09[core.websocket_server] - INFO - =======The above address is a websocket protocol address, please do not visit it with a browser=======
25-02-23 12:01:09[core.websocket_server] - INFO - If you want to test websocket, start the digital-human module and open the browser for interactive testing
25-02-23 12:01:09[core.websocket_server] - INFO - =======================================================
```

Because you are using full-module deployment, you have two important interfaces.

OTA interface:
```
http://your-computer-LAN-ip:8002/xiaozhi/ota/
```

Websocket interface:
```
ws://your-computer-LAN-ip:8000/xiaozhi/v1/
```

Please be sure to write both of the above interface addresses into the console: they will affect the websocket address distribution and the automatic upgrade function.

1、Using the super administrator account, log in to the console. In the top menu find `Parameter Management`, find the parameter with code `server.websocket`, and enter your `Websocket interface`.

2、Using the super administrator account, log in to the console. In the top menu find `Parameter Management`, find the parameter with code `server.ota`, and enter your `OTA interface`.

Next, you can start operating your esp32 device. You can either `compile the esp32 firmware yourself` or configure it to use the `firmware version 1.6.1 and above compiled by Xiaoge`. Choose either one.

1. [Compile your own esp32 firmware](firmware-build_en.md).

2. [Configure a custom server based on the firmware compiled by Xiaoge](firmware-setting_en.md).

# Frequently Asked Questions
Here are some common questions for reference:

1、[Why does Xiaozhi recognize a lot of my speech as Korean, Japanese, or English?](./FAQ_en.md)<br/>
2、[Why does "TTS task error: file does not exist" appear?](./FAQ_en.md)<br/>
3、[TTS often fails and frequently times out](./FAQ_en.md)<br/>
4、[WiFi can connect to my self-built server, but 4G mode cannot](./FAQ_en.md)<br/>
5、[How do I improve Xiaozhi's conversation response speed?](./FAQ_en.md)<br/>
6、[I speak very slowly, and Xiaozhi always interrupts me during pauses](./FAQ_en.md)<br/>
## Deployment-Related Tutorials
1、[How to automatically pull the latest project code, compile it, and start it](./dev-ops-integration.md)<br/>
2、[How to deploy an MQTT gateway to enable the MQTT+UDP protocol](./mqtt-gateway-integration.md)<br/>
3、[How to integrate with Nginx](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues/791)<br/>
## Extension-Related Tutorials
1、[How to enable phone-number registration for the console (optional)](./ali-sms-integration.md)<br/>
2、[How to integrate HomeAssistant for smart-home control](./homeassistant-integration.md)<br/>
3、[How to enable the vision model for photo recognition](./mcp-vision-integration.md)<br/>
4、[How to deploy an MCP endpoint](./mcp-endpoint-enable.md)<br/>
5、[How to connect to an MCP endpoint](./mcp-endpoint-integration.md)<br/>
6、[How to enable voiceprint recognition](./voiceprint-integration.md)<br/>
7、[News plugin source configuration guide](./newsnow_plugin_config.md)<br/>
8、[Weather plugin usage guide](./weather-integration.md)<br/>
## Voice Cloning and Local Speech Deployment Tutorials
1、[How to clone a voice in the console](./huoshan-streamTTS-voice-cloning.md)<br/>
2、[How to deploy and integrate index-tts local speech](./index-stream-integration.md)<br/>
3、[How to deploy and integrate fish-speech local speech](./fish-speech-integration.md)<br/>
4、[How to deploy and integrate PaddleSpeech local speech](./paddlespeech-deploy.md)<br/>
## Performance Testing Tutorials
1、[Component speed testing guide](./performance_tester.md)<br/>
2、[Periodically published test results](https://github.com/xinnan-tech/xiaozhi-performance-research)<br/>
