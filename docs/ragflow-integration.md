# ragflow Integration Guide

This tutorial consists of two parts:

- 1. How to deploy ragflow
- 2. How to configure the ragflow interface in the Console

If you are very familiar with ragflow and have already deployed it, you can skip Part 1 and go directly to Part 2. However, if you want guidance on deploying ragflow so that it can share the `mysql` and `redis` basic services with `xiaozhi-esp32-server` to reduce resource costs, you need to start from Part 1.

# Part 1 How to Deploy ragflow
## Step 1, Confirm whether mysql and redis are available

ragflow depends on the `mysql` database. If you have already deployed the `Console`, you have already installed `mysql`. You can share it.

You can try using the `telnet` command on the host machine to see whether the `3306` port of `mysql` can be accessed normally.
``` shell
telnet 127.0.0.1 3306

telnet 127.0.0.1 6379
```
If you can access the `3306` port and the `6379` port, ignore the following content and go directly to Step 2.

If you cannot access them, you need to recall how your `mysql` was installed.

If your mysql was installed by yourself using an installer package, it means your `mysql` has network isolation. You may first need to resolve the issue of accessing the `3306` port of `mysql`.

If your `mysql` was installed through this project's `docker-compose_all.yml`, you need to find the `docker-compose_all.yml` file you used to create the database and modify the following content.

Before modification
``` yaml
  xiaozhi-esp32-server-db:
    ...
    networks:
      - default
    expose:
      - "3306:3306"
  xiaozhi-esp32-server-redis:
    ...
    expose:
      - 6379
```

After modification
``` yaml
  xiaozhi-esp32-server-db:
    ...
    networks:
      - default
    ports:
      - "3306:3306"
  xiaozhi-esp32-server-redis:
    ...
    ports:
      - "6379:6379"
```

Note that you need to change `expose` to `ports` under `xiaozhi-esp32-server-db` and `xiaozhi-esp32-server-redis`. After the change, you need to restart. The following is the command to restart mysql:

``` shell
# Enter the folder where your docker-compose_all.yml is located; for example, mine is xiaozhi-server
cd xiaozhi-server
docker compose -f docker-compose_all.yml down
docker compose -f docker-compose.yml up -d
```

After startup, use the `telnet` command on the host machine again to see whether the `3306` port of `mysql` can be accessed normally.
``` shell
telnet 127.0.0.1 3306

telnet 127.0.0.1 6379
```
Normally it should be accessible now.

## Step 2, Create the database and tables
If your host machine can access the mysql database normally, create a database named `rag_flow` and a `rag_flow` user on mysql, with the password `infini_rag_flow`.

``` sql
-- Create the database
CREATE DATABASE IF NOT EXISTS rag_flow CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create the user and grant privileges
CREATE USER IF NOT EXISTS 'rag_flow'@'%' IDENTIFIED BY 'infini_rag_flow';
GRANT ALL PRIVILEGES ON rag_flow.* TO 'rag_flow'@'%';

-- Flush privileges
FLUSH PRIVILEGES;
```

## Step 3, Download the ragflow project

You need to find a folder on your computer to store the ragflow project. For example, mine is in the `/home/system/xiaozhi` folder.

You can use the `git` command to download the ragflow project into this folder. This tutorial uses version `v0.22.0` for installation and deployment.
```
git clone https://ghfast.top/https://github.com/infiniflow/ragflow.git
cd ragflow
git checkout v0.22.0
```
After downloading, enter the `docker` folder.
``` shell
cd docker
```
Modify the `docker-compose.yml` file in the `ragflow/docker` folder to remove the `depends_on` configuration of the `ragflow-cpu` and `ragflow-gpu` services, so as to release the `ragflow-cpu` service's dependency on `mysql`.

Here is the version before modification:
``` yaml
  ragflow-cpu:
    depends_on:
      mysql:
        condition: service_healthy
    profiles:
      - cpu
  ...
  ragflow-gpu:
    depends_on:
      mysql:
        condition: service_healthy
    profiles:
      - gpu
```
Here is the version after modification:
``` yaml
  ragflow-cpu:
    profiles:
      - cpu
  ...
  ragflow-gpu:
    profiles:
      - gpu
```

Next, modify the `docker-compose-base.yml` file in the `ragflow/docker` folder to remove the `mysql` and `redis` configuration.

For example, before deletion:
``` yaml
services:
  minio:
    image: quay.io/minio/minio:RELEASE.2025-06-13T11-33-47Z
    ...
  mysql:
    image: mysql:8.0
    ...
  redis:
    image: redis:6.2-alpine
    ...
```

After deletion
``` yaml
services:
  minio:
    image: quay.io/minio/minio:RELEASE.2025-06-13T11-33-47Z
    ...
```
## Step 4, Modify the environment variable configuration

Edit the `.env` file in the `ragflow/docker` folder, find the following configuration, and search and modify each one, one by one! Search and modify each one, one by one!

Regarding the modification of the `.env` file below, 60% of people ignore the `MYSQL_USER` configuration, which causes ragflow to fail to start. Therefore, this must be emphasized three times:

Emphasis 1: If your `.env` file does not have the `MYSQL_USER` configuration, please add this item to the configuration file!

Emphasis 2: If your `.env` file does not have the `MYSQL_USER` configuration, please add this item to the configuration file!

Emphasis 3: If your `.env` file does not have the `MYSQL_USER` configuration, please add this item to the configuration file!

``` env
# Port settings
SVR_WEB_HTTP_PORT=8008           # HTTP port
SVR_WEB_HTTPS_PORT=8009          # HTTPS port
# MySQL configuration - modify to your local MySQL information
MYSQL_HOST=host.docker.internal  # Use host.docker.internal to let the container access the host service
MYSQL_PORT=3306                  # Local MySQL port
MYSQL_USER=rag_flow              # The username created above; add this item if it does not exist
MYSQL_PASSWORD=infini_rag_flow   # The password set above
MYSQL_DBNAME=rag_flow            # Database name

# Redis configuration - modify to your local Redis information
REDIS_HOST=host.docker.internal  # Use host.docker.internal to let the container access the host service
REDIS_PORT=6379                  # Local Redis port
REDIS_PASSWORD=                  # If your Redis has no password set, fill it in like this; otherwise fill in the password
```

Note that if your Redis has no password set, you also need to modify `service_conf.yaml.template` in the `ragflow/docker` folder and replace `infini_rag_flow` with an empty string.

Before modification
``` shell
redis:
  db: 1
  password: '${REDIS_PASSWORD:-infini_rag_flow}'
  host: '${REDIS_HOST:-redis}:6379'
```
After modification
``` shell
redis:
  db: 1
  password: '${REDIS_PASSWORD:-}'
  host: '${REDIS_HOST:-redis}:6379'
```

## Step 5, Start the ragflow service
Run the command:
``` shell
docker-compose -f docker-compose.yml up -d
```
After it runs successfully, you can use the `docker logs -n 20 -f docker-ragflow-cpu-1` command to view the logs of the `docker-ragflow-cpu-1` service.

If there are no errors in the logs, it means the ragflow service started successfully.

# Step 5, Register an account
You can access `http://127.0.0.1:8008` in your browser, click `Sign Up`, and register an account.

After registration, you can click `Sign In` to log in to the ragflow service. If you want to disable the registration feature of the ragflow service and prevent others from registering accounts, you can set the `REGISTER_ENABLED` configuration item to `0` in the `.env` file in the `ragflow/docker` folder.

``` dotenv
REGISTER_ENABLED=0
```
After the modification, restart the ragflow service.
``` shell
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up -d
```

# Step 6, Configure the ragflow service's models
You can access `http://127.0.0.1:8008` in your browser, click `Sign In`, and log in to the ragflow service. Click the `avatar` in the upper-right corner of the page to enter the settings page.
First, in the left navigation bar, click `Model Providers` to enter the model configuration page. In the `Available Models` search box on the right, select `LLM`, choose the model provider you use from the list, click `Add`, and enter your key.
Then, select `TEXT EMBEDDING`, choose the model provider you use from the list, click `Add`, and enter your key.
Finally, refresh the page, then click the LLM and Embedding in the `Set Default Model` list respectively, and select the model you use. Please make sure your key has the corresponding service activated. For example, if the Embedding model I use is from xxx provider, I need to go to that provider's official website to check whether this model requires purchasing a resource package before it can be used.


# Part 2 Configure the ragflow service

# Step 1 Log in to the ragflow service
You can access `http://127.0.0.1:8008` in your browser, click `Sign In`, and log in to the ragflow service.

Then click the `avatar` in the upper-right corner to enter the settings page. In the left navigation bar, click the `API` feature, then click the "API Key" button. A dialog box appears.

In the dialog box, click the "Create new Key" button to generate an API Key. Copy this `API Key`; you will use it later.

# Step 2 Configure it in the Console
Make sure your Console version is `0.8.7` or above. Log in to the Console using a super administrator account.

First, you need to enable the knowledge base feature. In the top navigation bar, click `Parameter Dictionary`, then in the drop-down menu, click the `System Feature Configuration` page. On the page, check `Knowledge Base`, then click `Save Configuration`. You will then see the `Knowledge Base` feature in the navigation bar.

In the top navigation bar, click `Model Configuration`, then in the left navigation bar, click `Knowledge Base`. In the list, find `RAG_RAGFlow` and click the `Edit` button.

In `Service Address`, fill in `http://your-ragflow-service-LAN-IP:8008`. For example, if my ragflow service's LAN IP is `192.168.1.100`, then I fill in `http://192.168.1.100:8008`.

In `API Key`, fill in the `API Key` you copied earlier.

Finally, click the Save button.

# Step 2 Create a knowledge base
Log in to the Console using a super administrator account. In the top navigation bar, click `Knowledge Base`, then in the lower-left corner of the list, click the `Add` button. Fill in a name and description for the knowledge base, then click Save.

To improve the large model's understanding and recall of the knowledge base, it is recommended to fill in a meaningful name and description when creating the knowledge base. For example, if you want to create a knowledge base about `Company Introduction`, the knowledge base name could be `Company Introduction` and the description could be `Information about the company, such as basic company information, service items, contact phone, address, etc.`.

After saving, you can see this knowledge base in the knowledge base list. Click the `View` button of the knowledge base you just created to enter the knowledge base detail page.

On the knowledge base detail page, click the `Add` button in the lower-left corner to upload documents to the knowledge base.

After uploading, you can see the uploaded documents on the knowledge base detail page. You can then click the `Parse` button on a document to parse it.

After parsing is complete, you can view the parsed chunk information. You can click the `Recall Test` button on the knowledge base detail page to test the knowledge base's recall/retrieval functionality.

# Step 3 Make xiaozhi use the ragflow knowledge base
Log in to the Console. In the top navigation bar, click `Agents`, find the agent you want to configure, and click the `Configure Role` button.

To the left of Intent Recognition, click the `Edit Features` button; a dialog box appears. In the dialog box, select the knowledge base you want to add, then save.

