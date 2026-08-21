# Voiceprint Recognition Enablement Guide

This tutorial consists of 3 parts
- 1. How to deploy the voiceprint recognition service
- 2. How to configure the voiceprint recognition interface for full-module deployment
- 3. How to configure voiceprint recognition for minimal deployment

# 1. How to deploy the voiceprint recognition service

## Step 1: Download the voiceprint recognition project source code

Open the [voiceprint recognition project page](https://github.com/xinnan-tech/voiceprint-api) in your browser.

Once open, find a green button on the page labeled `Code`, click it, and you will see a `Download ZIP` button.

Click it to download the project source code archive. After downloading it to your computer, extract it. At this point its name may be `voiceprint-api-main`.
You need to rename it to `voiceprint-api`.

## Step 2: Create the database and tables

Voiceprint recognition depends on a `mysql` database. If you have already deployed the `Console`, it means you have installed `mysql`. You can share it.

You can try using the `telnet` command on the host machine to see whether you can access `mysql`'s `3306` port normally.
```
telnet 127.0.0.1 3306
```
If you can access port 3306, ignore the following content and go directly to Step 3.

If you cannot access it, you need to recall how your `mysql` was installed.

If your mysql was installed by yourself using an installer package, it means your `mysql` is network-isolated. You may need to first resolve the issue of accessing `mysql`'s `3306` port.

If your `mysql` was installed through this project's `docker-compose_all.yml`, you need to find the `docker-compose_all.yml` file you used to create the database and modify the following content.

Before modification
```
  xiaozhi-esp32-server-db:
    ...
    networks:
      - default
    expose:
      - "3306:3306"
```

After modification
```
  xiaozhi-esp32-server-db:
    ...
    networks:
      - default
    ports:
      - "3306:3306"
```

Note: change the `expose` under `xiaozhi-esp32-server-db` to `ports`. After the change, you need to restart. Here are the commands to restart mysql:

```
# Navigate to the folder containing your docker-compose_all.yml, e.g. mine is xiaozhi-server
cd xiaozhi-server
docker compose -f docker-compose_all.yml down
docker compose -f docker-compose.yml up -d
```

After startup, use the `telnet` command again on the host machine to see whether you can access `mysql`'s `3306` port.
```
telnet 127.0.0.1 3306
```
Normally it should be accessible now.

## Step 3: Create the database and tables
If your host machine can access the mysql database normally, create a database named `voiceprint_db` and a `voiceprints` table in mysql.

```
CREATE DATABASE voiceprint_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE voiceprint_db;

CREATE TABLE voiceprints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    speaker_id VARCHAR(255) NOT NULL UNIQUE,
    feature_vector LONGBLOB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_speaker_id (speaker_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Step 4: Configure the database connection

Enter the `voiceprint-api` folder and create a folder named `data`.

Copy `voiceprint.yaml` from the `voiceprint-api` root directory into the `data` folder, and rename it to `.voiceprint.yaml`.

Next, you need to focus on configuring the database connection in `.voiceprint.yaml`.

```
mysql:
  host: "127.0.0.1"
  port: 3306
  user: "root"
  password: "your_password"
  database: "voiceprint_db"
```

Note! Since your voiceprint recognition service is deployed using docker, `host` must be filled in with the `LAN IP of the machine where your mysql is located`.

Note! Since your voiceprint recognition service is deployed using docker, `host` must be filled in with the `LAN IP of the machine where your mysql is located`.

Note! Since your voiceprint recognition service is deployed using docker, `host` must be filled in with the `LAN IP of the machine where your mysql is located`.

## Step 5: Start the program
This project is a very simple project; it is recommended to run it using docker. However, if you do not want to run it with docker, you can refer to [this page](https://github.com/xinnan-tech/voiceprint-api/blob/main/README.md) to run it from source. Here is the docker method:

```
# Navigate to the project source root directory
cd voiceprint-api

# Clear cache
docker compose -f docker-compose.yml down
docker stop voiceprint-api
docker rm voiceprint-api
docker rmi ghcr.nju.edu.cn/xinnan-tech/voiceprint-api:latest

# Start the docker container
docker compose -f docker-compose.yml up -d
# View logs
docker logs -f voiceprint-api
```

At this point, the log will output logs similar to the following
```
250711 INFO-🚀 Start: production service startup (Uvicorn), listening address: 0.0.0.0:8005
250711 INFO-============================================================
250711 INFO-Voiceprint API address: http://127.0.0.1:8005/voiceprint/health?key=abcd
250711 INFO-============================================================
```

Please copy out the voiceprint API address:

Since you are deploying with docker, you must NOT use the address above directly!

Since you are deploying with docker, you must NOT use the address above directly!

Since you are deploying with docker, you must NOT use the address above directly!

First copy the address out and put it in a draft. You need to know your computer's LAN IP. For example, if my computer's LAN IP is `192.168.1.25`, then
my original interface address
```
http://127.0.0.1:8005/voiceprint/health?key=abcd

```
should be changed to
```
http://192.168.1.25:8005/voiceprint/health?key=abcd
```

After the change, please use a browser to directly visit the `voiceprint API address`. When the browser displays code similar to the following, it means it succeeded.
```
{"total_voiceprints":0,"status":"healthy"}
```

Please keep the modified `voiceprint API address`; you will need it in the next step.

# 2. How to configure voiceprint recognition for full-module deployment

## Step 1: Configure the interface
First, you need to enable the voiceprint recognition feature. In the Console, click `Parameter Dictionary` at the top, and in the dropdown menu click the `System Function Configuration` page. On the page, check `Voiceprint Recognition` and click `Save Configuration`. You can then see the `Voiceprint Recognition` button on the card for creating a new agent.

If you are doing full-module deployment, use an administrator account to log in to the Console, click `Parameter Dictionary` at the top, and select the `Parameter Management` function.

Then search for the parameter `server.voice_print`; at this time its value should be `null`.
Click the edit button, paste the `voiceprint API address` obtained in the previous step into the `parameter value`, then save.

If it saves successfully, everything is fine and you can go check the effect with your agent. If it fails, it means the Console cannot access the voiceprint recognition service. Most likely it is a network firewall, or the correct LAN IP was not filled in.

## Step 2: Set the agent memory mode

Enter the role configuration of your agent, set the memory to `Local short-term memory`, and be sure to enable `Report text + voice`.

## Step 3: Chat with your agent

Power on your device and chat with it at a normal speaking rate and tone.

## Step 4: Set up the voiceprint

In the Console's `Agent Management` page, in the agent's panel there is a `Voiceprint Recognition` button; click it. At the bottom there is an `Add` button. You can register a voiceprint for what a certain person says.
In the popup dialog, it is recommended to fill in the `Description` field; it can be the person's occupation, personality, and hobbies, making it easier for the agent to analyze and understand the speaker.

## Step 3: Chat with your agent

Power on your device and ask it: do you know who I am? If it can answer correctly, the voiceprint recognition feature is working normally.

# 3. How to configure voiceprint recognition for minimal deployment

## Step 1: Configure the interface
Open the `xiaozhi-server/data/.config.yaml` file (create it if it does not exist), then add/modify the following content:

```
# Voiceprint recognition configuration
voiceprint:
  # Voiceprint API address
  url: YOUR_VOICEPRINT_API_ADDRESS
  # Speaker configuration: speaker_id, name, description
  speakers:
    - "test1,Zhang San,Zhang San is a programmer"
    - "test2,Li Si,Li Si is a product manager"
    - "test3,Wang Wu,Wang Wu is a designer"
```

Paste the `voiceprint API address` obtained in the previous step into `url`, then save.

Add the `speakers` parameter according to your needs. Note the `speaker_id` parameter; you will use it later when registering voiceprints.

## Step 2: Register the voiceprint
If you have already started the voiceprint service, visit `http://localhost:8005/voiceprint/docs` in a local browser to view the API documentation. Here we only explain how to use the voiceprint registration API.

The voiceprint registration API address is `http://localhost:8005/voiceprint/register`, and the request method is POST.

The request header must include Bearer Token authentication. The token is the part after `?key=` in the `voiceprint API address`. For example, if my voiceprint registration address is `http://127.0.0.1:8005/voiceprint/health?key=abcd`, then my token is `abcd`.

The request body contains the speaker ID (`speaker_id`) and the WAV audio file (`file`). An example request is as follows:

```
curl -X POST \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -F "speaker_id=your_speaker_id_here" \
  -F "file=@/path/to/your/file" \
  http://localhost:8005/voiceprint/register
```

Here, `file` is the audio file of the speaker to be registered, and `speaker_id` must match the `speaker_id` configured in Step 1. For example, if I need to register Zhang San's voiceprint and I filled in `test1` as Zhang San's `speaker_id` in `.config.yaml`, then when registering Zhang San's voiceprint, the `speaker_id` in the request body should be `test1`, and `file` should be the audio file of Zhang San speaking a passage.

 ## Step 3: Start the service

Start the Xiaozhi server and the voiceprint service, and it will work normally.
