# How to Build a Docker Image Locally

This project already uses GitHub's automatic Docker image build feature. If you pulled an image released by the project and have no need to build your own image, you can ignore this document.

If you modified the source code and want to deploy and run it with Docker, follow the steps below:

## 1. Environment Preparation

Install Docker:
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## 2. Build the Image

When you have modified the code and need to build a new image, follow these steps:

Prepare your `username` and `new version number`.
- This `username` is the username you registered on Docker Hub, for example `xiaozhi`. Of course, if you don't need to push to Docker Hub, you can define it freely.
- This `new version number` is the image version you are building, for example `1.2.3`. You can customize it as needed or use a date format (e.g. `20260609`), mainly to distinguish it from the currently running version and to help you remember when you built it. Do not use the same version number as the one currently running on your machine.

Enter the `xiaozhi-esp32-server` project root directory and build the server and web images:

```bash
cd project-root

# Build the server image
docker build -f Dockerfile-server -t your-username/xiaozhi-esp32-server:new-version .

# Build the web image
docker build -f Dockerfile-web -t your-username/xiaozhi-esp32-server-web:new-version .

```

## 3. Modify the docker-compose Configuration

```bash
cd main/xiaozhi-server
```

Edit the `docker-compose_all.yml` file and replace the image version with the one you just built:

```yaml
services:
  xiaozhi-esp32-server:
    image: your-username/xiaozhi-esp32-server:new-version   # change to your image address
    ...

  xiaozhi-esp32-server-web:
    image: your-username/xiaozhi-esp32-server-web:new-version   # change to your image address
    ...
```

## 4. Restart the Service

```bash
# Stop the old containers
docker compose -f docker-compose_all.yml down

# Start the new containers
docker compose -f docker-compose_all.yml up -d
```

## 5. Verification

Check the logs to confirm the service started normally:

```bash
# View the server logs
docker logs -f -n 50 xiaozhi-esp32-server

# View the web logs
docker logs -f -n 50 xiaozhi-esp32-server-web
```
