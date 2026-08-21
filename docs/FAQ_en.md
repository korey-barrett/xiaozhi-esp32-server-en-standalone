# Frequently Asked Questions ❓

### 1、Why does Xiaozhi recognize a lot of my speech as Korean, Japanese, or English? 🇰🇷

Suggestion: check whether `models/SenseVoiceSmall` already contains the `model.pt`
file. If not, download it. See here [download the speech recognition model file](Deployment_en.md#model-files)

### 2、Why does "TTS task error: file does not exist" appear? 📁

Suggestion: check whether you correctly used `conda` to install the `libopus` and `ffmpeg` libraries.

If not installed, install them

```
conda install conda-forge::libopus
conda install conda-forge::ffmpeg
```

### 3、TTS often fails and frequently times out ⏰

Suggestion: if `EdgeTTS` fails often, first check whether you are using a proxy (VPN). If so, try closing the proxy and testing again;  
If you are using Volcano Engine's Doubao TTS, when it fails often it is recommended to use the paid version, because the test version only supports 2 concurrent connections.

### 4、WiFi can connect to my self-built server, but 4G mode cannot 🔐

Reason: Xiaoge's firmware requires a secure connection in 4G mode.

Solution: there are currently two ways to solve this. Choose one:

1、Modify the code. Refer to this video to solve it https://www.bilibili.com/video/BV18MfTYoE85

2、Use nginx to configure an SSL certificate. Refer to the tutorial https://icnt94i5ctj4.feishu.cn/docx/GnYOdMNJOoRCljx1ctecsj9cnRe

### 5、How do I improve Xiaozhi's conversation response speed? ⚡

This project's default configuration is a low-cost option. It is recommended that beginners first use the default free models to solve the problem of "getting it running", then optimize "making it fast".  
If you want to improve response speed, you can try replacing each component. Since version `0.5.2`, the project supports streaming configuration. Compared with earlier versions, response speed improves by about `2.5 seconds`, significantly improving the user experience.

| Module | Free entry setup | Streaming configuration |
|:---:|:---:|:---:|
| ASR (Speech Recognition) | FunASR (local) | 👍XunfeiStreamASR (Xunfei streaming) |
| LLM (Large Language Model) | glm-4-flash (Zhipu) | 👍qwen-flash (Alibaba Bailian) |
| VLLM (Vision LLM) | glm-4v-flash (Zhipu) | 👍qwen3.5-flash (Alibaba Bailian) |
| TTS (Speech Synthesis) | EdgeTTS (Microsoft) | 👍HuoshanDoubleStreamTTS (Volcano streaming) |
| Intent (Intent Recognition) | function_call | function_call |
| Memory | mem_local_short (local short-term memory) | mem_local_short (local short-term memory) |

If you care about the time each component takes, please refer to the [Xiaozhi component performance test report](https://github.com/xinnan-tech/xiaozhi-performance-research). You can actually test in your own environment using the methods in the report.

### 6、I speak very slowly, and Xiaozhi always interrupts me during pauses 🗣️

Suggestion: in the configuration file, find the following section and increase the value of `min_silence_duration_ms` (for example, change it to `1000`):

```yaml
VAD:
  SileroVAD:
    threshold: 0.5
    model_dir: models/snakers4_silero-vad
    min_silence_duration_ms: 700  # If you pause for a long time when speaking, you can increase this value
```

### 7、Deployment-Related Tutorials
1、[How to perform the minimal deployment](./Deployment_en.md)<br/>
2、[How to perform the full-module deployment](./Deployment_all_en.md)<br/>
3、[How to deploy an MQTT gateway to enable the MQTT+UDP protocol](./mqtt-gateway-integration.md)<br/>
4、[How to automatically pull the latest project code, compile it, and start it](./dev-ops-integration.md)<br/>
5、[How to integrate with Nginx](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues/791)<br/>
6、[After modifying code, how to compile your own Docker image](./docker-build.md)<br/>

### 8、Firmware Compilation Tutorials
1、[How to compile the Xiaozhi firmware yourself](./firmware-build_en.md)<br/>
2、[How to modify the OTA address based on the firmware compiled by Xiaoge](./firmware-setting_en.md)<br/>
3、[How to configure firmware OTA auto-upgrade in single-module deployment](./ota-upgrade-guide_en.md)<br/>

### 9、Extension-Related Tutorials
1、[How to enable phone-number registration for the console (optional)](./ali-sms-integration.md)<br/>
2、[How to integrate HomeAssistant for smart-home control](./homeassistant-integration.md)<br/>
3、[How to enable the vision model for photo recognition](./mcp-vision-integration.md)<br/>
4、[How to deploy an MCP endpoint](./mcp-endpoint-enable.md)<br/>
5、[How to connect to an MCP endpoint](./mcp-endpoint-integration.md)<br/>
6、[How to get device information via an MCP method](./mcp-get-device-info.md)<br/>
7、[How to enable voiceprint recognition](./voiceprint-integration.md)<br/>
8、[News plugin source configuration guide](./newsnow_plugin_config.md)<br/>
9、[Knowledge base RAGFlow integration guide](./ragflow-integration.md)<br/>
10、[How to deploy context sources](./context-provider-integration.md)<br/>
11、[How to integrate PowerMem smart memory](./powermem-integration.md)<br/>
12、[How to configure the weather plugin to query the weather](./weather-integration.md)<br/>
13、[How to enable the device call plugin](./device-call-guide.md)<br/>
14、[How to enable the web search feature](./web-search-integration.md)<br/>

### 10、Digital Human Tutorials
1、[digital-human startup method](./digital-human-wakeword.md)<br/>
2、[How to deploy digital-human on an N100 mini PC](./all-in-one-digital-human-setup.md)<br/>

### 11、Voice Cloning and Local Speech Deployment Tutorials
1、[How to clone a voice in the console](./huoshan-streamTTS-voice-cloning.md)<br/>
2、[How to deploy and integrate index-tts local speech](./index-stream-integration.md)<br/>
3、[How to deploy and integrate fish-speech local speech](./fish-speech-integration.md)<br/>
4、[How to deploy and integrate PaddleSpeech local speech](./paddlespeech-deploy.md)<br/>

### 12、Performance Testing Tutorials
1、[Component speed testing guide](./performance_tester.md)<br/>
2、[Periodically published test results](https://github.com/xinnan-tech/xiaozhi-performance-research)<br/>

### 13、For more questions, please contact us 💬

You can submit your questions in [issues](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues).
