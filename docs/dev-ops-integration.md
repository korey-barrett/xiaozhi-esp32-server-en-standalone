# Automatic Upgrade Method for All-Module Source Deployment

This tutorial helps fans of all-module source deployment learn how to use automatic commands to automatically pull the source code, compile it, and start the ports, achieving the most efficient upgrade system.

This project's test platform `https://2662r3426b.vicp.fun` has used this method since it opened, with good results.

You can refer to the video tutorial published by the Bilibili blogger `Bile labs`: [《Open-source Xiaozhi server xiaozhi-server automatic update and latest-version MCP access point configuration beginner's tutorial》](https://www.bilibili.com/video/BV15H37zHE7Q)

# Prerequisites
- Your computer/server runs a Linux operating system
- You have already run through the entire process successfully
- You like keeping up with the latest features but find manual deployment every time a bit troublesome, and you want an automatic update method

The second condition must be met, because some of the files involved in this tutorial — the JDK, Node.js environment, Conda environment, etc. — are only available after you have run through the entire process. If you have not done so, when I mention a certain file, you may not know what it means.

# Tutorial Outcomes
- Solves the problem of being unable to pull the latest project source code in China
- Automatically pulls the code and compiles the frontend files
- Automatically pulls the code and compiles the Java files, automatically kills port 8002, and automatically starts port 8002
- Automatically pulls the Python code, automatically kills port 8000, and automatically starts port 8000

# Step 1: Choose Your Project Directory

For example, I have planned my project directory as follows. This is a newly created, empty directory. If you want to avoid errors, you can use the same layout as mine.
```
/home/system/xiaozhi
```

# Step 2: Clone This Project
At this point, run the first command first to pull the source code. This command works for servers and computers on domestic (China) networks without needing a VPN.

```
cd /home/system/xiaozhi
git clone https://github.com/korey-barrett/xiaozhi-esp32-server-en-standalone.git
```

After running it, your project directory will have an additional folder `xiaozhi-esp32-server`, which is the project source code.

# Step 3: Copy the Base Files

If you have already run through the entire process, you will be familiar with two files: the funasr model file `xiaozhi-server/models/SenseVoiceSmall/model.pt` and your private configuration file `xiaozhi-server/data/.config.yaml`.

At this point you need to copy the `model.pt` file to the new directory. You can do it like this:
```
# Create the required directories
mkdir -p /home/system/xiaozhi/xiaozhi-esp32-server/main/xiaozhi-server/data/

cp YOUR_ORIGINAL_.config.yaml_FULL_PATH /home/system/xiaozhi/xiaozhi-esp32-server/main/xiaozhi-server/data/.config.yaml
cp YOUR_ORIGINAL_model.pt_FULL_PATH /home/system/xiaozhi/xiaozhi-esp32-server/main/xiaozhi-server/models/SenseVoiceSmall/model.pt
```

# Step 4: Create Three Automatic Build Scripts

## 4.1 Automatically Build the manager-web Module
In the `/home/system/xiaozhi/` directory, create a file named `update_8001.sh` with the following contents

```
cd /home/system/xiaozhi/xiaozhi-esp32-server
git fetch --all
git reset --hard
git pull origin main


cd /home/system/xiaozhi/xiaozhi-esp32-server/main/manager-web
npm install
npm run build
rm -rf /home/system/xiaozhi/manager-web
mv /home/system/xiaozhi/xiaozhi-esp32-server/main/manager-web/dist /home/system/xiaozhi/manager-web
```

After saving, run the permission-granting command
```
chmod 777 update_8001.sh
```
After running it, continue below

## 4.2 Automatically Build and Run the manager-api Module
In the `/home/system/xiaozhi/` directory, create a file named `update_8002.sh` with the following contents

```
cd /home/system/xiaozhi/xiaozhi-esp32-server
git pull origin main


cd /home/system/xiaozhi/xiaozhi-esp32-server/main/manager-api
rm -rf target
mvn clean package -Dmaven.test.skip=true
cd /home/system/xiaozhi/

# Find the process ID occupying port 8002
PID=$(sudo netstat -tulnp | grep 8002 | awk '{print $7}' | cut -d'/' -f1)

rm -rf /home/system/xiaozhi/xiaozhi-esp32-api.jar
mv /home/system/xiaozhi/xiaozhi-esp32-server/main/manager-api/target/xiaozhi-esp32-api.jar /home/system/xiaozhi/xiaozhi-esp32-api.jar

# Check whether a process ID was found
if [ -z "$PID" ]; then
  echo "No process occupying port 8002 was found"
else
  echo "Found the process occupying port 8002, process ID: $PID"
  # Kill the process
  kill -9 $PID
  kill -9 $PID
  echo "Process $PID killed"
fi

nohup java -jar xiaozhi-esp32-api.jar --spring.profiles.active=dev &

tail tail -f nohup.out
```

After saving, run the permission-granting command
```
chmod 777 update_8002.sh
```
After running it, continue below

## 4.3 Automatically Build and Run the Python Project
In the `/home/system/xiaozhi/` directory, create a file named `update_8000.sh` with the following contents

```
cd /home/system/xiaozhi/xiaozhi-esp32-server
git pull origin main

# Find the process ID occupying port 8000
PID=$(sudo netstat -tulnp | grep 8000 | awk '{print $7}' | cut -d'/' -f1)

# Check whether a process ID was found
if [ -z "$PID" ]; then
  echo "No process occupying port 8000 was found"
else
  echo "Found the process occupying port 8000, process ID: $PID"
  # Kill the process
  kill -9 $PID
  kill -9 $PID
  echo "Process $PID killed"
fi
cd main/xiaozhi-server
# Initialize the conda environment
source ~/.bashrc
conda activate xiaozhi-esp32-server
pip install -r requirements.txt
nohup python app.py >/dev/null &
tail -f /home/system/xiaozhi/xiaozhi-esp32-server/main/xiaozhi-server/tmp/server.log
```

After saving, run the permission-granting command
```
chmod 777 update_8000.sh
```
After running it, continue below

# Daily Updates

Once all the scripts above are in place, for daily updates we just need to run the following commands in sequence to automatically update and start.

```
cd /home/system/xiaozhi
# Update and start the Java program
./update_8001.sh
# Update the web program
./update_8002.sh
# Update and start the python program
./update_8000.sh


# To view the java log later, run the following command
tail -f nohup.out
# To view the python log later, run the following command
tail -f /home/system/xiaozhi/xiaozhi-esp32-server/main/xiaozhi-server/tmp/server.log
```

# Notes
The test platform `https://2662r3426b.vicp.fun` uses nginx as a reverse proxy. For the detailed nginx.conf configuration, you can refer to here

## FAQ

### 1. Why don't I see port 8001?
Answer: Port 8001 is used in the development environment to run the frontend. For server deployment, it is not recommended to start the frontend on port 8001 using `npm run serve`; instead, compile it into HTML files as in this tutorial, and use nginx to manage access.

### 2. Do I need to manually update SQL statements on every update?
Answer: No, because the project uses **Liquibase** to manage database versions and will automatically run new SQL scripts.