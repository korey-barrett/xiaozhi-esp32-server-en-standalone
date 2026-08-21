# All-in-One Digital Human Setup Guide

This project is used to deploy a complete digital human display system on x86 architecture devices (such as mini PCs, industrial PCs, regular computers, etc.), providing the following features:
- Automatically enter a full-screen Kiosk browser on startup to display a specified webpage
- Run a wake-word detection service in the background to support voice interaction

> **Note**: This document uses the **Intel N100 mini PC (Tianhong QN10-100B4)** as an example for the deployment walkthrough. Other x86 devices can be adjusted by reference (note the differences in network configuration and sound card devices).

## Supported Environment

| Item | Description |
|------|------|
| Example Hardware | Tianhong QN10-100B4 (Intel N100) |
| Operating System | Ubuntu 24.04 LTS (Noble Numbat) |
| Example User | xz (replace according to your actual situation) |
| Network | Wi-Fi connection with a fixed IP (can be switched to wired as needed) |

## Deployment Workflow

1. System initialization (change mirrors, connect to network)
2. Install graphics components and the Kiosk browser
3. Configure auto-login and the graphical interface
4. Deploy the wake-word service (Python environment + microphone)
5. Optimize boot time and hide startup information

---


### System Initialization (Change Mirrors, Connect to Network)

```
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

sudo tee /etc/apt/sources.list > /dev/null <<EOF
deb http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse
EOF

echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
```


Install the network management tool (you can skip this if it already exists)

Bash

```
sudo apt update
sudo apt install network-manager -y
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
```


Set the Wi-Fi password and a fixed IP

> **Reminder**: The Wi-Fi name, password, and IP address in the following commands are examples. Be sure to replace them with your own actual information.

Bash

```
sudo nmcli device wifi connect "MERCURY_1812" password "12345678"

sudo nmcli connection modify "MERCURY_1812" ipv4.addresses "192.168.0.86/24" ipv4.gateway "192.168.0.1" ipv4.dns "8.8.8.8,114.114.114.114" ipv4.method "manual"

sudo nmcli connection up "MERCURY_1812"
```


### Step 1: Install the Core Graphics Components and Browser

Here we stick to "minimalism" and firmly avoid installing any extra desktop environments (such as GNOME/KDE). We only install the low-level drivers, the lightest window manager (Openbox), a mouse-hiding tool, and the Chromium browser.

Bash

```
sudo timedatectl set-timezone Asia/Shanghai


sudo apt install net-tools vim fonts-wqy-microhei fonts-wqy-zenhei alsa-utils pulseaudio -y
sudo apt install --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox unclutter -y

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y
rm google-chrome-stable_current_amd64.deb

sudo apt purge snapd -y

```

### Step 2: Configure Passwordless Auto-Login on TTY1

To avoid the awkwardness of typing in a username and password manually, we modify the systemd service so the system automatically logs in as `xz` right after boot. We use one-shot write commands here to completely sidestep save failures caused by mishandling `nano` or `vi`.

**1. Create the configuration directory:**

Bash

```
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
```

**2. Write the auto-login rule:**

Bash

```
echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin xz --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
```

**3. Reload the service and set the default boot target:**

Bash

```
sudo systemctl daemon-reload
sudo systemctl set-default multi-user.target
```

### Step 3: Configure Auto-Starting the Graphical Interface After Login

After automatic login the system stays on the black-and-white command line by default. We need to configure a script so the X11 graphical environment starts immediately once you log in.

**1. Trigger the startup logic for `startx`:**

Append the trigger code directly to your personal environment configuration file:

Bash

```
cat << 'EOF' >> ~/.bash_profile
if [ -z "$DISPLAY" ] && [ "$(fgconsole)" -eq 1 ]; then
    exec startx
fi
EOF
```

**2. Tell `startx` to launch Openbox:**

Bash

```
echo "exec openbox-session" > ~/.xinitrc
```

### Step 4: Configure a "Fortress-Like" Openbox and Browser

This is the most critical step: disable screen sleep, hide the mouse, lock the browser into fullscreen, and write an "infinite loop" so the browser springs right back to life if it is closed unexpectedly.

**1. Create the Openbox configuration directory:**

Bash

```
mkdir -p ~/.config/openbox
```

**2. Write the autostart script (`autostart`):**

Copy the entire block below and press Enter (this automatically writes all the protection rules into the file):

Bash

```
cat << 'EOF' > ~/.config/openbox/autostart
# Disable the screen saver
xset -dpms
xset s noblank
xset s off

# Hide the mouse
unclutter -idle 0.1 -root &

# Start Chromium in an infinite loop (restarts instantly even after a crash or manual close)
while true; do
    google-chrome \
        --kiosk \
        --no-first-run \
        --no-default-browser-check \
        --disable-infobars \
        --disable-session-crashed-bubble \
        --disable-translate \
        --disable-external-intent-requests \
        --autoplay-policy=no-user-gesture-required \
        --use-fake-ui-for-media-stream \
        "https://www.douyin.com"
    sleep 2
done &
EOF
```

**3. Disable the `Alt+F4` exit shortcut:**

To prevent someone from plugging in a keyboard and forcibly closing the window, we remove Openbox's default system shortcut.

Bash

```
cp /etc/xdg/openbox/rc.xml ~/.config/openbox/
sed -i '/<keybind key="A-F4">/,/<\/keybind>/d' ~/.config/openbox/rc.xml
```

### Step 5: Restart and Verify the Result

If you have unplugged the network cable or do not need to wait for all networks to come online, you can disable the network-wait services to avoid boot-time lag

Bash

```
sudo systemctl mask systemd-networkd-wait-online.service
sudo systemctl mask NetworkManager-wait-online.service
```

Hide the startup information (GRUB)

Bash

```
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 systemd.show_status=false vt.global_cursor_default=0"/g' /etc/default/grub

echo 'GRUB_TIMEOUT_STYLE="hidden"' | sudo tee -a /etc/default/grub
echo 'GRUB_RECORDFAIL_TIMEOUT=0' | sudo tee -a /etc/default/grub

sudo update-grub
```

Set the volume to 100%, then reboot:

Bash

```
amixer -q sset Master 100% unmute
sudo reboot
```

### Deploying the Wake-Word Service

To deploy the wake-word detection service on the all-in-one device, you need to install a Python environment, upload the project files, configure the Camera microphone, and set up auto-start on boot.

#### 1. Install Miniconda

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
~/miniconda3/bin/conda init bash
source ~/.bashrc
rm Miniconda3-latest-Linux-x86_64.sh
```


Make sure you automatically enter the conda environment at login

```bash
if ! grep -q '.bashrc' ~/.bash_profile; then
    cat << 'EOF' >> ~/.bash_profile

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF
fi
```


#### 2. Create a Python Virtual Environment

```bash
conda create -n test python=3.10 -y
conda activate test
```

If you get a "Terms of Service have not been accepted" error, run:

```bash
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
```

#### 3. Upload the Project Files

Upload the entire `main/digital-human/` directory from your development machine to the `~/digital-human/` directory on the all-in-one device:

```bash
# Run this on the development machine (replace <all-in-one-IP> with the actual IP)
scp -r main/digital-human/ xz@<all-in-one-IP>:~/digital-human/
```

#### 4. Install System Dependencies

The wake-word service needs the audio capture library and the ALSA PulseAudio plugin:

```bash
sudo apt install libportaudio2 portaudio19-dev libasound2-plugins -y
```

#### 5. Install Python Dependencies

```bash
cd ~/digital-human/wakeword_runtime
pip install numpy
pip install -r requirements.txt
```

#### 6. Download the Wake-Word Model

The model files are not included in the project and need to be downloaded and configured separately. See the "Model Download" section in [docs/digital-human-wakeword.md](digital-human-wakeword.md).

#### 7. Modify the Openbox Autostart Script

You need to add the PulseAudio and Camera microphone configuration to autostart, and change the Chrome address to a test page.

First confirm the device name of the Camera microphone in PulseAudio:

```bash
pulseaudio --start
pactl list sources short
```

Find the line containing `USB_Camera` and note down the full name, for example:

```
alsa_input.usb-SN0002_2K_USB_Camera_46435000_P030D00_SN0002-02.mono-fallback
```

Then overwrite autostart with the full content below (replace `TARGET_MIC` with your actual device name):

```bash
cat << 'EOF' > ~/.config/openbox/autostart
# 1. Start the sound service and wait a moment
pulseaudio --start
sleep 1

# 2. Lock the Camera's microphone (replace with your actual device name)
TARGET_MIC="alsa_input.usb-SN0002_2K_USB_Camera_46435000_P030D00_SN0002-02.mono-fallback"

# 3. Set it as the system default microphone
pactl set-default-source "$TARGET_MIC"

# 4. Unmute
pactl set-source-mute "$TARGET_MIC" 0

# 5. Set the volume to 100%
pactl set-source-volume "$TARGET_MIC" 100%

# --- Minimal desktop and browser environment configuration ---

# Disable the screen saver
xset -dpms
xset s noblank
xset s off

# Hide the mouse
unclutter -idle 0.1 -root &

# Start the browser in an infinite loop (restarts instantly even after a crash or manual close)
while true; do
    google-chrome \
        --kiosk \
        --no-first-run \
        --no-default-browser-check \
        --disable-infobars \
        --disable-session-crashed-bubble \
        --disable-translate \
        --disable-external-intent-requests \
        --autoplay-policy=no-user-gesture-required \
        --use-fake-ui-for-media-stream \
        "http://127.0.0.1:8006/index.html"
    sleep 2
done &
EOF
```

#### 8. Configure the Wake-Word Service to Auto-Start on Boot

Create a systemd service file so the wake-word service runs automatically at boot.

First confirm the current user's UID:

```bash
id -u $(whoami)
```

Then replace `1000` below with the UID you found (usually the first user is 1000):

```bash
sudo tee /etc/systemd/system/digital-human.service << 'EOF'
[Unit]
Description=Digital Human Runtime
After=network.target sound.target

[Service]
Type=simple
User=xz
Environment=XDG_RUNTIME_DIR=/run/user/1000
Environment=PULSE_SERVER=unix:/run/user/1000/pulse/native
WorkingDirectory=/home/xz/digital-human
ExecStartPre=/bin/sleep 10
ExecStart=/home/xz/miniconda3/envs/test/bin/python start.py
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```

> **Important Notes**:
> - `User=xz` — replace with your actual username
> - `/run/user/1000` — replace with your actual UID
> - The paths in `WorkingDirectory` and `ExecStart` — replace with your actual deployment paths
> - The PulseAudio environment variables in `Environment` **must be kept**, otherwise the wake-word service and the browser cannot use the Camera microphone at the same time

Enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable digital-human
sudo systemctl start digital-human
```

#### 9. Common Service Management Commands

```bash
sudo systemctl start digital-human     # Start immediately
sudo systemctl stop digital-human      # Stop
sudo systemctl restart digital-human   # Restart
sudo systemctl status digital-human    # View status
journalctl -u digital-human -f         # View live logs
```

