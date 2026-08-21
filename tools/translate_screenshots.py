#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
translate_screenshots.py
========================
Batch-translate Chinese UI screenshots to English using a local Ollama
vision model (default: qwen2.5vl:7b).

For every image file in the input folder, it sends the image + a prompt to
Ollama and produces, per image:
    <output>/<name>.txt          -> the raw model output (原文: / EN: lines)
    <output>/<name>.chinese.txt  -> just the extracted Chinese lines, for QA

With `--json` it additionally builds a merged Chinese->English dictionary:
    <output>/translations.json   -> { "原文chinese": "English translation" }

The flat key-value dict is easy to merge into the project's i18n files, e.g.
manager-web's src/i18n/en.js (each key is `'some.path': 'value'`) by finding
the matching Chinese value in zh_CN.js and inserting the English value.

Requirements:
    - Ollama running locally with a vision model pulled:
          ollama pull qwen2.5vl:7b
    - Python 3.8+ (standard library only — no pip installs needed)

Usage:
    # Translate every image in a folder:
    python tools/translate_screenshots.py [input_dir] [output_dir] [--json]

    # Translate the images embedded in a Markdown file (e.g. README/docs):
    python tools/translate_screenshots.py --markdown README.md [output_dir] [--json]

Environment overrides:
    OLLAMA_HOST   default http://127.0.0.1:11434
    OLLAMA_MODEL  default qwen2.5vl:7b
    OLLAMA_TEMPERATURE  default 0.2 (low = more faithful/repeatable)
"""

import argparse
import base64
import json
import os
import re
import sys
import urllib.request

DEFAULT_MODEL = "qwen2.5vl:7b"

# OLLAMA_HOST may be a full URL or a bare host[:port] (e.g. "192.168.0.198").
_RAW_HOST = os.environ.get("OLLAMA_HOST", "http://127.0.0.1:11434").strip().rstrip("/")
if not _RAW_HOST.startswith(("http://", "https://")):
    if ":" not in _RAW_HOST:
        _RAW_HOST = _RAW_HOST + ":11434"
    _RAW_HOST = "http://" + _RAW_HOST
HOST = _RAW_HOST
TEMPERATURE = float(os.environ.get("OLLAMA_TEMPERATURE", "0.2"))

IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".webp", ".bmp", ".gif"}

# ---------------------------------------------------------------------------
# The exact prompt sent to the model (edit this to suit your translation style).
# ---------------------------------------------------------------------------
PROMPT = """You are a translator working on an English-localized UI project.

Read the Chinese text rendered in this image. For EVERY piece of Chinese UI text
you can see (labels, buttons, titles, menu items, placeholders, toast messages),
output it line by line in this exact format:

原文: <original Chinese exactly as shown>
EN: <concise, natural English translation suitable for a UI label>

Rules:
- Translate the meaning, not word-by-word; match real UI wording style.
- Keep product/feature names and model/provider names in English.
- Do NOT invent text; if some text is blurred or unclear, mark it (unclear).
- Preserve placeholders like {0}, %s, {{name}} exactly as-is.
- Output ONLY the list — no preamble, no commentary.
- If the image contains NO Chinese text at all, reply with exactly: NO_CHINESE"""

# ---------------------------------------------------------------------------
# Core call to Ollama /api/generate
# ---------------------------------------------------------------------------
def call_ollama(image_path, model):
    with open(image_path, "rb") as fh:
        img_b64 = base64.b64encode(fh.read()).decode("ascii")

    payload = {
        "model": model,
        "prompt": PROMPT,
        "images": [img_b64],
        "stream": False,
        "options": {"temperature": TEMPERATURE},
    }
    req = urllib.request.Request(
        f"{HOST}/api/generate",
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=180) as resp:
        data = json.loads(resp.read().decode("utf-8"))
    return data.get("response", "").strip()


# ---------------------------------------------------------------------------
# Parse the model's "原文: X / EN: Y" lines into a {chinese: english} dict.
# ---------------------------------------------------------------------------
def parse_pairs(text):
    pairs = {}
    current_cn = None
    for raw in text.splitlines():
        line = raw.strip()
        if line.startswith("原文:") or line.startswith("原文："):
            current_cn = line.split(":", 1)[1].strip().strip('"').strip("“”")
        elif line.upper().startswith("EN:") or line.upper().startswith("EN："):
            if current_cn is None:
                continue
            en = line.split(":", 1)[1].strip().strip('"').strip("“”")
            if current_cn and en:
                pairs.setdefault(current_cn, en)
            current_cn = None
    return pairs


def find_images(input_dir):
    imgs = []
    for root, _dirs, files in os.walk(input_dir):
        for fn in sorted(files):
            if os.path.splitext(fn)[1].lower() in IMAGE_EXTS:
                imgs.append(os.path.join(root, fn))
    return imgs


def is_local_image(path):
    """True if path looks like a local image file (not a remote/http URL)."""
    low = path.lower()
    if "://" in low or low.startswith("data:"):
        return False
    return os.path.splitext(low)[1].lower() in IMAGE_EXTS


def collect_from_markdown(md_path):
    """Return the absolute paths of local images embedded in a Markdown file."""
    with open(md_path, "r", encoding="utf-8") as fh:
        text = fh.read()
    base = os.path.dirname(os.path.abspath(md_path))
    found = []

    # Markdown images: ![alt](path)  and  ![alt](path "title")
    for m in re.finditer(r"!\[[^\]]*\]\(([^)]+)\)", text):
        raw = m.group(1).strip()
        target = raw.split()[0]  # strip any title after a space
        target = target.split("#")[0].split("?")[0]
        if is_local_image(target):
            found.append(os.path.normpath(os.path.join(base, target)))

    # HTML <img src="..."> tags
    for m in re.finditer(r"<img[^>]+src=[\"']([^\"']+)[\"']", text):
        target = m.group(1).strip()
        if is_local_image(target):
            found.append(os.path.normpath(os.path.join(base, target)))

    # Dedupe while preserving order.
    seen, imgs = set(), []
    for p in found:
        if p not in seen:
            seen.add(p)
            imgs.append(p)
    return imgs


def main():
    # Avoid UnicodeEncodeError on Windows cp1252 consoles when printing help/docstring.
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")

    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("input_dir", nargs="?", help="folder of screenshots")
    ap.add_argument("output_dir", nargs="?", help="output folder (default: <input>_en)")
    ap.add_argument("--markdown", metavar="MD", help="scan a Markdown file for embedded local images instead of a folder")
    ap.add_argument("--json", action="store_true", help="also write a merged translations.json")
    ap.add_argument("--report", action="store_true", help="also write images_report.json mapping each image to its English pairs")
    args = ap.parse_args()

    if args.markdown:
        src = os.path.abspath(args.markdown)
        if not os.path.isfile(src):
            print(f"[error] markdown file not found: {src}")
            sys.exit(2)
        images = collect_from_markdown(src)
        src_label = src
        default_out = os.path.join(os.path.dirname(src), "docs_images_en")
    else:
        if not args.input_dir:
            ap.print_help()
            sys.exit(2)
        src = os.path.abspath(args.input_dir)
        if not os.path.isdir(src):
            print(f"[error] input dir not found: {src}")
            sys.exit(2)
        images = find_images(src)
        src_label = src
        default_out = src + "_en"

    output_dir = os.path.abspath(args.output_dir) if args.output_dir else default_out
    model = os.environ.get("OLLAMA_MODEL", DEFAULT_MODEL)

    if not images:
        print(f"[warn] no local images found (markdown={args.markdown})")
        return
    os.makedirs(output_dir, exist_ok=True)

    print(f"Model : {model}")
    print(f"Host  : {HOST}")
    print(f"Input : {src_label}  ({len(images)} images)")
    print(f"Output: {output_dir}")
    print("---")

    ok = fail = 0
    merged = {}
    report = {}
    with_chinese = {}
    for img in images:
        name = os.path.splitext(os.path.basename(img))[0]
        out_txt = os.path.join(output_dir, name + ".txt")
        out_cn = os.path.join(output_dir, name + ".chinese.txt")

        print(f"[*] {name} ...", flush=True)
        try:
            text = call_ollama(img, model)
        except Exception as exc:  # noqa: BLE001
            fail += 1
            print(f"    ! FAILED: {exc}", flush=True)
            continue

        with open(out_txt, "w", encoding="utf-8") as fh:
            fh.write(text + "\n")

        pairs = parse_pairs(text)
        has_chinese = bool(pairs) and "NO_CHINESE" not in text
        cn_lines = list(pairs.keys())
        with open(out_cn, "w", encoding="utf-8") as fh:
            fh.write("\n".join(cn_lines) + "\n")

        merged.update(pairs)
        report[img] = {"has_chinese": has_chinese, "strings": pairs}
        if has_chinese:
            with_chinese[img] = pairs
        ok += 1
        tag = f"{len(pairs)} strings" if has_chinese else "no Chinese"
        print(f"  -> {out_txt}  ({tag})", flush=True)

    if args.json:
        json_path = os.path.join(output_dir, "translations.json")
        with open(json_path, "w", encoding="utf-8") as fh:
            json.dump(merged, fh, ensure_ascii=False, indent=2)
        print(f"  -> {json_path}  ({len(merged)} total strings)")

    if args.report:
        report_path = os.path.join(output_dir, "images_report.json")
        with open(report_path, "w", encoding="utf-8") as fh:
            json.dump(report, fh, ensure_ascii=False, indent=2)
        print(f"  -> {report_path}  ({len(report)} images)")

        chinese_path = os.path.join(output_dir, "chinese_images.json")
        with open(chinese_path, "w", encoding="utf-8") as fh:
            json.dump(with_chinese, fh, ensure_ascii=False, indent=2)
        print(f"  -> {chinese_path}  ({len(with_chinese)} images with Chinese)")

    print("---")
    print(f"Done. {ok} ok, {fail} failed. "
          f"{len(with_chinese)} of {ok} images contain Chinese text.")


if __name__ == "__main__":
    main()
