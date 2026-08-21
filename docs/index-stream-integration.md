# IndexStreamTTS Usage Guide

## Environment Preparation
### 1. Clone the Project
```bash 
git clone https://github.com/Ksuriuri/index-tts-vllm.git
```
Enter the extracted directory
```bash
cd index-tts-vllm
```
Switch to the specified version (use the historical version for VLLM-0.10.2)
```bash
git checkout 224e8d5e5c8f66801845c66b30fa765328fd0be3
```

### 2. Create and Activate the conda Environment
```bash 
conda create -n index-tts-vllm python=3.12
conda activate index-tts-vllm
```

### 3. Install PyTorch, Version 2.8.0 Required (latest version)
#### Check the highest version supported by your GPU and the version actually installed
```bash
nvidia-smi
nvcc --version
``` 
#### Highest CUDA version supported by the driver
```bash
CUDA Version: 12.8
```
#### CUDA compiler version actually installed
```bash
Cuda compilation tools, release 12.8, V12.8.89
```
#### The corresponding install command (pytorch defaults to the 12.8 driver version)
```bash
pip install torch torchvision
```
You need pytorch version 2.8.0 (corresponding to vllm 0.10.2). For specific install instructions, please refer to: [pytorch official site](https://pytorch.org/get-started/locally/)

### 4. Install Dependencies
```bash 
pip install -r requirements.txt
```

### 5. Download the Model Weights
### Option One: Download the official weights and convert them
These are the official weight files. Download them to any local path; IndexTTS-1.5 weights are supported  
| HuggingFace                                                   | ModelScope                                                          |
|---------------------------------------------------------------|---------------------------------------------------------------------|
| [IndexTTS](https://huggingface.co/IndexTeam/Index-TTS)        | [IndexTTS](https://modelscope.cn/models/IndexTeam/Index-TTS)        |
| [IndexTTS-1.5](https://huggingface.co/IndexTeam/IndexTTS-1.5) | [IndexTTS-1.5](https://modelscope.cn/models/IndexTeam/IndexTTS-1.5) |

Below we use the ModelScope installation method as an example  
#### Please note: git needs to be installed and lfs initialized and enabled (you can skip this if already installed)
```bash
sudo apt-get install git-lfs
git lfs install
```
Create a model directory and pull the model
```bash 
mkdir model_dir
cd model_dir
git clone https://www.modelscope.cn/IndexTeam/IndexTTS-1.5.git
```

#### Model Weight Conversion
```bash 
bash convert_hf_format.sh /path/to/your/model_dir
```
For example, if your downloaded IndexTTS-1.5 model is stored in the model_dir directory, run the following command
```bash
bash convert_hf_format.sh model_dir/IndexTTS-1.5
```
This operation converts the official model weights to a transformers-library-compatible version and saves them in the `vllm` folder under the model weight path, making it convenient for the vllm library to load the model weights later

### 6. Modify the Interface to Fit the Project
The interface return data is not compatible with the project and needs to be adjusted so it directly returns audio data
```bash
vi api_server.py
```
```bash 
@app.post("/tts", responses={
    200: {"content": {"application/octet-stream": {}}},
    500: {"content": {"application/json": {}}}
})
async def tts_api(request: Request):
    try:
        data = await request.json()
        text = data["text"]
        character = data["character"]

        global tts
        sr, wav = await tts.infer_with_ref_audio_embed(character, text)

        return Response(content=wav.tobytes(), media_type="application/octet-stream")
        
    except Exception as ex:
        tb_str = ''.join(traceback.format_exception(type(ex), ex, ex.__traceback__))
        print(tb_str)
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "error": str(tb_str)
            }
        )
```

### 7. Write the sh startup script (please note that it must be run in the corresponding conda environment)
```bash 
vi start_api.sh
```
### Paste the following content in and save by typing `:wq`
#### Please change `/home/system/index-tts-vllm/model_dir/IndexTTS-1.5` in the script to your actual path
```bash
# activate the conda environment
conda activate index-tts-vllm 
echo "Project conda environment activated"
sleep 2
# find the process occupying port 11996
PID_VLLM=$(sudo netstat -tulnp | grep 11996 | awk '{print $7}' | cut -d'/' -f1)

# check whether a process number was found
if [ -z "$PID_VLLM" ]; then
  echo "No process was found occupying port 11996"
else
  echo "Found the process occupying port 11996, process number: $PID_VLLM"
  # first try a normal kill, wait 2 seconds
  kill $PID_VLLM
  sleep 2
  # check whether the process is still running
  if ps -p $PID_VLLM > /dev/null; then
    echo "The process is still running, forcing termination..."
    kill -9 $PID_VLLM
  fi
  echo "Terminated process $PID_VLLM"
fi

# find the process occupying the VLLM::EngineCore
GPU_PIDS=$(ps aux | grep -E "VLLM|EngineCore" | grep -v grep | awk '{print $2}')

# check whether a process number was found
if [ -z "$GPU_PIDS" ]; then
  echo "No VLLM-related process was found"
else
  echo "Found VLLM-related process(es), process number(s): $GPU_PIDS"
  # first try a normal kill, wait 2 seconds
  kill $GPU_PIDS
  sleep 2
  # check whether the process is still running
  if ps -p $GPU_PIDS > /dev/null; then
    echo "The process is still running, forcing termination..."
    kill -9 $GPU_PIDS
  fi
  echo "Terminated process $GPU_PIDS"
fi

# create the tmp directory (if it does not exist)
mkdir -p tmp

# run api_server.py in the background, redirecting the log to tmp/server.log
nohup python api_server.py --model_dir /home/system/index-tts-vllm/model_dir/IndexTTS-1.5 --port 11996 > tmp/server.log 2>&1 &
echo "api_server.py is running in the background; see tmp/server.log for the log"
```
Give the script execute permission and run it
```bash 
chmod +x start_api.sh
./start_api.sh
```
The log will be output to tmp/server.log. You can view the log with the following command
```bash
tail -f tmp/server.log
```
If your GPU memory is sufficient, you can add the startup parameter `--gpu_memory_utilization` to the script to adjust the video-memory usage ratio; the default value is 0.25

## Timbre Configuration
index-tts-vllm supports registering custom timbres through a configuration file, and supports both single-timbre and mixed-timbre configuration.  
Configure custom timbres in the `assets/speaker.json` file at the project root directory
### Configuration Format Description
```bash
{
    "Speaker Name 1": [
        "audio_file_path_1.wav",
        "audio_file_path_2.wav"
    ],
    "Speaker Name 2": [
        "audio_file_path_3.wav"
    ]
}
```
### Note (after configuring roles you need to restart the service to register the timbres)
After adding, you need to add the corresponding speaker in the Console (for a single-module setup, change the corresponding `voice` accordingly)