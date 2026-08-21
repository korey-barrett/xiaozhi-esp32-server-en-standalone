# Starting the Digital Human (digital-human)

## Overview

The test page integrates high-precision voice wake-up based on **Sherpa-ONNX**, supporting custom wake words and real-time detection. It uses a lightweight keyword detection model with millisecond-level response speed.

## Wake Word Model

### Model Download (Required)

**Important**: The project does not include the model files; you need to download and configure them in advance.

### Official Model Download URLs

- **Official model list**: <https://csukuangfj.github.io/sherpa/onnx/kws/pretrained_models/index.html>
- **Recommended model**: `sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01`

### Download and Configuration Steps

#### 1. Download the Model Package

```bash
# Method 1: Direct download (recommended)
cd main/digital-human/wakeword_runtime/
wget https://github.com/k2-fsa/sherpa-onnx/releases/download/kws-models/sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01.tar.bz2

# Extract
tar xvf sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01.tar.bz2

# Method 2: Use ModelScope
pip install modelscope
python -c "
from modelscope import snapshot_download
snapshot_download('pkufool/sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01', cache_dir='./models')
"
```

#### 2. Configure the Model Files

After downloading, the model package contains the following files:

```
sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01/
├── encoder-epoch-12-avg-2-chunk-16-left-64.int8.onnx    # speed-first
├── encoder-epoch-12-avg-2-chunk-16-left-64.onnx
├── encoder-epoch-99-avg-1-chunk-16-left-64.int8.onnx    # speed-first
├── encoder-epoch-99-avg-1-chunk-16-left-64.onnx         # accuracy-first
├── decoder-epoch-12-avg-2-chunk-16-left-64.onnx
├── decoder-epoch-99-avg-1-chunk-16-left-64.onnx         # accuracy-first
├── joiner-epoch-12-avg-2-chunk-16-left-64.int8.onnx     # speed-first
├── joiner-epoch-12-avg-2-chunk-16-left-64.onnx
├── joiner-epoch-99-avg-1-chunk-16-left-64.int8.onnx     # speed-first
├── joiner-epoch-99-avg-1-chunk-16-left-64.onnx          # accuracy-first
├── tokens.txt                    # token mapping table (required)
├── keywords_raw.txt              # may be bundled with the model package (optional, runtime does not depend on it)
├── keywords.txt                  # ready-made
├── test_wavs/                    # test audio (optional)
├── configuration.json            # model metadata (optional)
└── README.md                     # documentation (optional)
```

#### 3. Choose a Configuration Scheme

**Scheme 1: Accuracy-first (recommended)**

```bash
cd sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01

# Create the model directory
mkdir -p ../models

# Copy the accuracy-first epoch-99 fp32 trio
cp encoder-epoch-99-avg-1-chunk-16-left-64.onnx ../models/encoder.onnx
cp decoder-epoch-99-avg-1-chunk-16-left-64.onnx ../models/decoder.onnx
cp joiner-epoch-99-avg-1-chunk-16-left-64.onnx ../models/joiner.onnx

# Copy the accompanying files
cp tokens.txt ../models/tokens.txt
# If keywords_raw.txt is bundled with the model package, you may keep it; the runtime does not depend on it
```

**Scheme 2: Speed-first**

```bash
cd sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01

# Create the model directory
mkdir -p ../models

# Copy the speed-first epoch-99 int8 trio
cp encoder-epoch-99-avg-1-chunk-16-left-64.int8.onnx ../models/encoder.onnx
cp decoder-epoch-99-avg-1-chunk-16-left-64.onnx ../models/decoder.onnx
cp joiner-epoch-99-avg-1-chunk-16-left-64.int8.onnx ../models/joiner.onnx

# Copy the accompanying files
cp tokens.txt ../models/tokens.txt
```

**Notes**:

- **Do not mix fp32 and int8**: the three model files must have consistent precision
- **Prefer epoch-99**: it is trained more thoroughly than epoch-12 and offers higher accuracy
- **Required files**: `encoder.onnx` + `decoder.onnx` + `joiner.onnx` + `tokens.txt` + `keywords.txt`

### Final Model File Structure

After configuration, the model files should be placed in the `wakeword_runtime/models/` directory, with the full path `main/digital-human/wakeword_runtime/models/`:

```
wakeword_runtime/models/
├── encoder.onnx      # encoder model (after renaming)
├── decoder.onnx      # decoder model (after renaming)
├── joiner.onnx       # joiner model (after renaming)
├── tokens.txt        # pinyin token mapping table (228-line version)
├── keywords.txt      # keyword configuration file (auto-generated on first start)
└── keywords_raw.txt  # optional, runtime does not depend on it
```

## How to Start

Run in the `main/digital-human` directory:

```bash
pip install -r wakeword_runtime/requirements.txt
python start.py
```

Default addresses after startup:

- Page address: `http://127.0.0.1:8006/index.html`
- Event bridge address: `ws://127.0.0.1:8006/wakeword-ws`
- Health check: `http://127.0.0.1:8006/health`

How to stop:

- Press `Ctrl+C` in the running terminal
- This stops the static page server, event bridge, and wake word detection flow at the same time

## Configuration File Description

The configuration file is located at [main/digital-human/wakeword_runtime/config.json](../main/digital-human/wakeword_runtime/config.json).

Main configuration items:

```json
{
  "wakeword": {
    "enabled": true
  },
  "model_dir": "models",
  "audio": {
    "input_device": null,
    "sample_rate": 16000,
    "channels": 1
  },
  "detector": {
    "num_threads": 4,
    "provider": "cpu",
    "max_active_paths": 2,
    "keywords_score": 1.8,
    "keywords_threshold": 0.1,
    "num_trailing_blanks": 1,
    "cooldown_seconds": 1.5
  },
  "logging": {
    "level": "INFO",
    "dir": "logs",
    "file": "wakeword-runtime.log"
  }
}
```

Meaning of each field:

| Parameter | Description |
| --- | --- |
| `wakeword.enabled` | Whether to enable local wake word detection |
| `model_dir` | Directory containing the model and vocabulary files |
| `audio.input_device` | Microphone input device; defaults to the system default device |
| `audio.sample_rate` | Sample rate, default `16000` |
| `audio.channels` | Number of channels, default `1` |
| `detector.num_threads` | Detector thread count |
| `detector.provider` | Inference provider, currently usually `cpu` |
| `detector.max_active_paths` | Number of search paths |
| `detector.keywords_score` | Keyword boost score |
| `detector.keywords_threshold` | Detection threshold |
| `detector.num_trailing_blanks` | Number of trailing blanks |
| `detector.cooldown_seconds` | Cooldown time between consecutive triggers |
| `logging.level` | Log level |
| `logging.dir` | Log directory |
| `logging.file` | Log file name |

## Recommended Workflow

### First-time Use

1. Prepare the model files and `tokens.txt` in the `models/` directory
2. Confirm that `models/keywords.txt` exists
3. Run `python start.py` in the `digital-human` directory
4. Open `http://127.0.0.1:8006/index.html` in a browser
5. Go to the settings page and check the "Wake Word" configuration

### Changing the Wake Word

1. Open the digital human page settings
2. Switch to the "Wake Word" tab
3. Change the enable status or the wake word list
4. Click "Apply Wake Word"
5. Follow the prompt to decide whether to restart immediately

### Disabling the Wake Word

1. Change "Enable local wake word" to disabled
2. Click "Apply Wake Word"
3. It is recommended to restart once immediately

After disabling:

- The page and event bridge remain available
- Wake word detection will no longer run
