# Performance Tester Usage Guide for Speech Recognition, Large Language Models, Non-Streaming Speech Synthesis, Streaming Speech Synthesis, and Vision Models

1. In the main/xiaozhi-server directory, create the data directory
2. In the data directory, create the .config.yaml file
3. In .data/config.yaml, write the parameters for your speech recognition, large language model, streaming speech synthesis, and vision models.
For example:
```
LLM:
  ChatGLMLLM:
    # Define the LLM API type
    type: openai
    # glm-4-flash is free, but you still need to register and fill in the api_key
    # You can find your api key here https://bigmodel.cn/usercenter/proj-mgmt/apikeys
    model_name: glm-4-flash
    url: https://open.bigmodel.cn/api/paas/v4/
    api_key: your chat-glm web key

TTS:

VLLM:

ASR:
```
4. In the main/xiaozhi-server directory, run performance_tester.py:
```
python performance_tester.py
```