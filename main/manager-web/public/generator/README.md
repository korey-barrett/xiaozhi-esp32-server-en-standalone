# Voice Box Theme Customization

## Project Overview

This directory contains static files packaged from the [xiaozhi-assets-generator](https://github.com/xinnan-tech/xiaozhi-assets-generator) project, used for online customization and generation of voice box themes. Users can configure elements such as wake words, fonts, expressions, and chat backgrounds through this tool, and export them as an `assets.bin` file.

## Directory Structure

```
generator/
├── assets/              # Built resource files
│   ├── ft_render-ByO_jG18.js
│   ├── index-CYcyz9xb.js
│   └── index-NXxBVrod.css
├── static/              # Static resource directory
│   ├── charsets/        # Charset files
│   │   ├── deepseek.txt
│   │   ├── gb2312.txt
│   │   ├── latin1.txt
│   │   └── qwen18409.txt
│   ├── fonts/           # Font resources
│   │   ├── font_noto_qwen_14_1.bin
│   │   ├── font_noto_qwen_16_4.bin
│   │   ├── font_noto_qwen_20_4.bin
│   │   ├── font_noto_qwen_30_4.bin
│   │   ├── font_puhui_deepseek_14_1.bin
│   │   ├── font_puhui_deepseek_16_4.bin
│   │   ├── font_puhui_deepseek_20_4.bin
│   │   ├── font_puhui_deepseek_30_4.bin
│   │   ├── noto_qwen.ttf
│   │   └── puhui_deepseek.ttf
│   ├── multinet_model/  # Custom wake word models
│   │   ├── fst/
│   │   ├── mn6_cn/
│   │   ├── mn6_en/
│   │   ├── mn7_cn/
│   │   └── mn7_en/
│   ├── twemoji32/       # 32x32 expression images
│   ├── twemoji64/       # 64x64 expression images
│   ├── wakenet_model/   # Preset wake word models
│   └── README.md        # Static resource description
├── index.html           # Main page
└── README.md            # Project documentation
```

## Main Features

### 1. Chip and Screen Configuration
- Supports multiple chip models: ESP32-S3, ESP32-C3, ESP32-P4, ESP32-C6
- Flexible screen resolution settings
- Supports RGB565 color format

### 2. Wake Word Configuration
- **Preset wake words**: WakeNet models based on different chip support
- **Custom wake words**: Supports Chinese and English command words, with configurable threshold and timeout

### 3. Font Configuration
- Multiple preset fonts: Alibaba PuHuiTi, Noto Qwen, etc.
- Supports uploading custom TTF/WOFF font files
- Configurable font size and color depth (bpp)

### 4. Expression Set
- Provides 21 basic expression presets (in 32x32 and 64x64 sizes)
- Supports custom expression uploads

### 5. Chat Background
- Supports light/dark mode switching
- Configurable solid color or image background
- Automatically adapts to screen resolution

## Usage

1. Start the `index.html` file as a service
2. Select the chip model and screen configuration
3. Configure theme elements through the different tabs
4. Click the generate button to view the resource manifest
5. Generate and download the `assets.bin` file after confirmation

## Technical Notes

- Built static resources are located in the `assets/` directory
- Original models and resource files are located in the `static/` directory
- Supports offline use, no additional dependencies required

## Notes

- This tool is designed for offline use; all resources are included in the directory
- The generated `assets.bin` file must be used with voice box hardware
- When using custom resources, note the file format and size limits to ensure compatibility
