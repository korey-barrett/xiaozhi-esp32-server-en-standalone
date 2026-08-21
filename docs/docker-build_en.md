# How to Build Docker Images Locally

Now this project uses GitHub's `automatic Docker image build` feature. If you are pulling the images published by the project, you do not need to build images yourself — you can ignore this document.

If you modified the source code and want to deploy and run it with the `docker` method, you can follow the steps below:

## 1、Environment Preparation

Install Docker:
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## 2、Build the Image

When you have modified the code and need to build a new image, follow these steps:

Prepare your `your-username` and `new-version-number`.
- This `your-username` is the username you registered on `docker hub`, for example `xiaozhi`. Of course, if you do not need to push to `docker hub`, you can define it freely.
- This `new-version-number` is the version number of the image you build, for example `1.2.3`. You can customize it as needed or use a date format (for example `20260609`). This mainly makes it easy to distinguish from the currently running version, and also makes it easy to remember when you built it next time. Do not use the same version number as the one currently running on your machine.

Enter the root directory of the `xiaozhi-esp32-server` project, and build both the server and web images:

```bash
cd project-root-directory

# Build the server image
docker build -f Dockerfile-server -t your-username/xiaozhi-esp32-server:new-version-number .

# Build the web image
docker build -f Dockerfile-web -t your-username/xiaozhi-esp32-server-web:new-version-number .

```

## 3、Modify the docker-compose Configuration

```bash
cd main/xiaozhi-server
```

Edit the `docker-compose_all.yml` file, and replace the image version with the version you just built:

```yaml
services:
  xiaozhi-esp32-server:
    image: your-username/xiaozhi-esp32-server:new-version-number   # change to your image address
    ...

  xiaozhi-esp32-server-web:
    image: your-username/xiaozhi-esp32-server-web:new-version-number   # change to your image address
    ...
```

## 4、Restart the Service

```bash
# Stop the old container
docker compose -f docker-compose_all.yml down

# Start the new container
docker compose -f docker-compose_all.yml up -d
```

## 5、Verify

Check the logs to confirm the service started normally:

```bash
# View the server log
docker logs -f -n 50 xiaozhi-esp32-server

# View the web log
docker logs -f -n 50 xiaozhi-esp32-server-web
```
