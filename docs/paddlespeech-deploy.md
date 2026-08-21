# Integrating xiaozhi with PaddleSpeechTTS

## Key Notes
- Pros: local offline deployment, fast
- Cons: as of September 25, 2025, the default model is a Chinese model and does not support English-to-speech. If the text contains English, no sound will be produced. To support both Chinese and English, you need to train your own model.

## 1. Basic Environment Requirements
Operating system: Windows / Linux / WSL 2

Python version: 3.9 or above (adjust according to the official Paddle tutorial)

Paddle version: latest official version   ```https://www.paddlepaddle.org.cn/install```

Dependency management tool: conda or venv

## 2. Start the paddlespeech service
### 1. Clone the source from the official paddlespeech repository
```bash 
git clone https://github.com/PaddlePaddle/PaddleSpeech.git
```
### 2. Create a virtual environment
```bash

conda create -n paddle_env python=3.10 -y
conda activate paddle_env
```
### 3. Install paddle
Because CPU and GPU architectures differ, create the environment according to the Python version officially supported by Paddle.
```
https://www.paddlepaddle.org.cn/install
```

### 4. Enter the paddlespeech directory
```bash
cd PaddleSpeech
```
### 5. Install paddlespeech
```bash
pip install pytest-runner -i https://pypi.tuna.tsinghua.edu.cn/simple

#Use any one of the following commands
pip install paddlepaddle -i https://mirror.baidu.com/pypi/simple
pip install paddlespeech -i https://pypi.tuna.tsinghua.edu.cn/simple
```
### 6. Use the command to automatically download the speech model
```bash
paddlespeech tts --input "你好，这是一次测试"
```
This step automatically downloads the model cache to the local `.paddlespeech/models` directory.

### 7. Modify the tts_online_application.yaml configuration
Reference directory ```"PaddleSpeech\demos\streaming_tts_server\conf\tts_online_application.yaml"```
Select the ```tts_online_application.yaml``` file, open it with an editor, and set ```protocol``` to ```websocket```.

### 8. Start the service
```yaml
paddlespeech_server start --config_file ./demos/streaming_tts_server/conf/tts_online_application.yaml
#Official default startup command:
paddlespeech_server start --config_file ./conf/tts_online_application.yaml
```
Adjust the startup command according to the actual directory of your ```tts_online_application.yaml```. The service is started successfully when you see the following log.
```
Prefix dict has been built successfully.
[2025-08-07 10:03:11,312] [   DEBUG] __init__.py:166 - Prefix dict has been built successfully.
INFO:     Started server process [2298]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8092 (Press CTRL+C to quit)
```

## 3. Modify the xiaozhi configuration files
### 1.```main/xiaozhi-server/core/providers/tts/paddle_speech.py```

### 2.```main/xiaozhi-server/data/.config.yaml```
Deploy with a single module
```yaml
selected_module:
  TTS: PaddleSpeechTTS
TTS:
  PaddleSpeechTTS:
      type: paddle_speech
      protocol: websocket 
      url:  ws://127.0.0.1:8092/paddlespeech/tts/streaming  # TTS service URL, pointing to the local server [websocket default: ws://127.0.0.1:8092/paddlespeech/tts/streaming]
      spk_id: 0  # Speaker ID, 0 usually indicates the default speaker
      sample_rate: 24000  # Sample rate [websocket default: 24000, http default: 0 auto-select]
      speed: 1.0  # Speech speed, 1.0 is normal, >1 is faster, <1 is slower
      volume: 1.0  # Volume, 1.0 is normal, >1 is louder, <1 is quieter
      save_path:   # Save path
```
### 3. Start the xiaozhi service
```py
python app.py
```
After starting `python start.py` under `main/digital-human`, open `http://127.0.0.1:8006/index.html` and test the connection. When sending a message, check whether the paddlespeech side outputs any logs.

Sample output log:
```
INFO:     127.0.0.1:44312 - "WebSocket /paddlespeech/tts/streaming" [accepted]
INFO:     connection open
[2025-08-07 11:16:33,355] [    INFO] - sentence: 哈哈，怎么突然找我聊天啦？
[2025-08-07 11:16:33,356] [    INFO] - The durations of audio is: 2.4625 s
[2025-08-07 11:16:33,356] [    INFO] - first response time: 0.1143045425415039 s
[2025-08-07 11:16:33,356] [    INFO] - final response time: 0.4777836799621582 s
[2025-08-07 11:16:33,356] [    INFO] - RTF: 0.19402382942625715
[2025-08-07 11:16:33,356] [    INFO] - Other info: front time: 0.06514096260070801 s, first am infer time: 0.008037090301513672 s, first voc infer time: 0.04112648963928223 s,
[2025-08-07 11:16:33,356] [    INFO] - Complete the synthesis of the audio streams
INFO:     connection closed

```
