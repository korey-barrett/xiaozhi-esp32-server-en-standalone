# Frequently Asked Questions ❓

### 1. Why does Xiaozhi recognize so much Korean, Japanese, and English in what I say? 🇰🇷

Suggestion: Check whether `models/SenseVoiceSmall` already contains a `model.pt` file. If not, download it. See [Download the speech recognition model file](Deployment.md#model-files)

### 2. Why does "TTS task error, file does not exist" occur? 📁

Suggestion: Check whether you correctly installed the `libopus` and `ffmpeg` libraries with `conda`.

If not installed, install them

```
conda install conda-forge::libopus
conda install conda-forge::ffmpeg
```

### 3. TTS often fails and often times out ⏰

Suggestion: If `EdgeTTS` frequently fails, first check whether you are using a proxy. If so, try turning off the proxy and try again.  
If you are using Volcano Engine's Doubao TTS, consider using the paid version when it frequently fails, because the trial version only supports 2 concurrent connections.

### 4. I can connect to a self-hosted server over WiFi, but the 4G mode cannot connect 🔐

Reason: Xiaoge's firmware requires a secure connection in 4G mode.

Solution: There are currently two ways to resolve this. Choose either:

1. Modify the code. Refer to this video https://www.bilibili.com/video/BV18MfTYoE85

2. Use nginx to configure an SSL certificate. Refer to the tutorial https://icnt94i5ctj4.feishu.cn/docx/GnYOdMNJOoRCljx1ctecsj9cnRe

### 5. How can I improve Xiaozhi's conversation response speed? ⚡

This project defaults to a low-cost configuration. Beginners are advised to start with the default free models to solve the "it runs" problem, then optimize "it runs fast".  
To improve response speed, you can try upgrading the components. Since version `0.5.2`, the project supports streaming configuration, which improves response speed by about `2.5 seconds` compared to earlier versions and significantly improves the user experience.

| Module | Budget all-free setup | Streaming configuration |
|:---:|:---:|:---:|
| ASR (speech recognition) | FunASR (local) | 👍XunfeiStreamASR (iFlytek streaming) |
| LLM (large model) | glm-4-flash (Zhipu) | 👍qwen-flash (Alibaba Bailian) |
| VLLM (vision large model) | glm-4v-flash (Zhipu) | 👍qwen3.5-flash (Alibaba Bailian) |
| TTS (speech synthesis) | EdgeTTS (Microsoft) | 👍HuoshanDoubleStreamTTS (Volcano streaming) |
| Intent (intent recognition) | function_call | function_call |
| Memory (memory feature) | mem_local_short (local short-term memory) | mem_local_short (local short-term memory) |

If you care about the latency of each component, please refer to the Xiaozhi component performance test report; you can test in your own environment following the test methods in the report.

### 6. I speak slowly, and Xiaozhi keeps interrupting me during pauses 🗣️

Suggestion: In the configuration file, find the following section and increase the value of `min_silence_duration_ms` (for example, change it to `1000`):

```yaml
VAD:
  SileroVAD:
    threshold: 0.5
    model_dir: models/snakers4_silero-vad
    min_silence_duration_ms: 700  # If you pause for a long time when speaking, increase this value
```

### 7. Deployment-related tutorials
1. [How to do the simplest deployment](./Deployment.md)<br/>
2. [How to do a full-module deployment](./Deployment_all.md)<br/>
3. [How to deploy the MQTT gateway to enable MQTT+UDP protocol](./mqtt-gateway-integration.md)<br/>
4. [How to automatically pull the latest code of this project, build, and start it](./dev-ops-integration.md)<br/>
5. How to integrate with Nginx<br/>
6. [How to build your own Docker image after modifying the code](./docker-build.md)<br/>

### 8. Firmware compilation-related tutorials
1. [How to compile the Xiaozhi firmware yourself](./firmware-build.md)<br/>
2. [How to modify the OTA address based on Xiaoge's precompiled firmware](./firmware-setting.md)<br/>
3. [How to configure automatic OTA firmware upgrade in a single-module deployment](./ota-upgrade-guide.md)<br/>

### 9. Extension-related tutorials
1. [How to enable phone-number registration for the Console (optional)](./ali-sms-integration.md)<br/>
2. [How to integrate HomeAssistant for smart-home control](./homeassistant-integration.md)<br/>
3. [How to enable the vision model for photo-based object recognition](./mcp-vision-integration.md)<br/>
4. [How to deploy an MCP endpoint](./mcp-endpoint-enable.md)<br/>
5. [How to connect to an MCP endpoint](./mcp-endpoint-integration.md)<br/>
6. [How MCP methods obtain device information](./mcp-get-device-info.md)<br/>
7. [How to enable voiceprint recognition](./voiceprint-integration.md)<br/>
8. [News plugin source configuration guide](./newsnow_plugin_config.md)<br/>
9. [Knowledge base RAGFlow integration guide](./ragflow-integration.md)<br/>
10. [How to deploy a context source](./context-provider-integration.md)<br/>
11. [How to integrate PowerMem smart memory](./powermem-integration.md)<br/>
12. [How to configure the weather plugin to query the weather](./weather-integration.md)<br/>
13. [How to enable the device call plugin](./device-call-guide.md)<br/>
14. [How to enable web search](./web-search-integration.md)<br/>

### 10. Digital human-related tutorials
1. [How to start the digital-human module](./digital-human-wakeword.md)<br/>
2. [How to deploy digital-human on an N100 mini PC](./all-in-one-digital-human-setup.md)<br/>

### 11. Voice clone and local voice deployment-related tutorials
1. [How to clone a timbre in the Console](./huoshan-streamTTS-voice-cloning.md)<br/>
2. [How to deploy and integrate the index-tts local voice](./index-stream-integration.md)<br/>
3. [How to deploy and integrate the fish-speech local voice](./fish-speech-integration.md)<br/>
4. [How to deploy and integrate PaddleSpeech local voice](./paddlespeech-deploy.md)<br/>

### 12. Performance testing tutorials
1. [Component speed test guide](./performance_tester.md)<br/>
2. Regularly published test results<br/>

### 13. More questions — contact us to report feedback 💬

You can submit your questions in the [issues](https://github.com/korey-barrett/xiaozhi-esp32-server-en-standalone/issues) section.