#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_doc_captions.py
========================
Build English alt-text / captions for every image referenced in the repo's
Markdown docs (README.md and docs/**/*.md), using the Chinese->English strings
already extracted by translate_screenshots.py.

For each Markdown file and each embedded image it finds, it looks up that
image's English strings (from images_report.json) and the nearest preceding
Markdown heading, and emits a suggested alt-text / caption.

Output:
    doc_captions.md     human-readable captions
    doc_captions.json   machine-readable {md_file: {img: alt}}

Usage:
    python tools/generate_doc_captions.py [--output DIR] [--report images_report.json]
"""

import argparse
import glob
import json
import os
import re
import sys

IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".webp", ".gif", ".bmp"}

MD_IMAGE = re.compile(r"!\[([^\]]*)\]\(([^)]+)\)")
MD_IMG_SRC = re.compile(r"<img[^>]+src=[\"']([^\"']+)[\"']")
HEADING = re.compile(r"^(#{1,6})\s+(.*)$")


def is_local(p):
    low = p.lower()
    if "://" in low or low.startswith("data:"):
        return False
    return os.path.splitext(low)[1].lower() in IMAGE_EXTS


def collect_refs(text, base):
    """Return list of (alt, abs_path, orig_target) for local images in markdown."""
    refs = []
    for m in MD_IMAGE.finditer(text):
        alt = m.group(1).strip()
        target = m.group(2).strip().split()[0].split("#")[0].split("?")[0]
        if is_local(target):
            refs.append((alt, os.path.normpath(os.path.join(base, target)), target))
    for m in MD_IMG_SRC.finditer(text):
        target = m.group(1).strip()
        if is_local(target):
            refs.append(("", os.path.normpath(os.path.join(base, target)), target))
    seen, out = set(), []
    for alt, p, orig in refs:
        if p not in seen:
            seen.add(p)
            out.append((alt, p, orig))
    return out


def heading_at(text, idx):
    """Return the most recent heading line strictly before index idx."""
    best = None
    for m in HEADING.finditer(text):
        if m.start() >= idx:
            break
        best = (len(m.group(1)), m.group(2).strip())
    return best


def nice_caption(image_alt, heading, image_abs, image_translations):
    """Build an English alt-text from heading context + the image's English strings."""
    # Topic: prefer the surrounding heading, else a readable filename.
    if heading and heading[1]:
        topic = heading[1]
    else:
        topic = os.path.splitext(os.path.basename(image_abs))[0]
        topic = topic.replace("_", " ").replace("-", " ").strip().title()

    # Look up this image's English UI strings.
    info = image_translations.get(image_abs)
    samples = []
    if info and info.get("strings"):
        samples = list(info["strings"].values())[:6]

    if image_alt:
        base = image_alt
    else:
        base = topic

    if samples:
        shown = ", ".join('"%s"' % s for s in samples)
        return "%s — UI text shown: %s." % (base, shown)
    return "%s." % base


def main():
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")

    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--output", default="docs_images_en", help="output folder (default docs_images_en)")
    ap.add_argument("--report", default=None, help="path to images_report.json (default <output>/images_report.json)")
    args = ap.parse_args()

    repo = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
    report_path = args.report or os.path.join(args.output, "images_report.json")
    if not os.path.isfile(report_path):
        print(f"[error] report not found: {report_path} (run translate_screenshots.py first)")
        sys.exit(2)
    image_translations = json.load(open(report_path, encoding="utf-8"))

    md_files = set()
    for pat in ("README.md", "docs/**/*.md"):
        md_files.update(glob.glob(os.path.join(repo, pat), recursive=True))
    md_files = sorted(md_files)

    captions = {}
    replacements = {}
    for md in md_files:
        text = open(md, encoding="utf-8").read()
        base = os.path.dirname(md)
        entry = {}
        lines = []
        for alt, img_abs, orig in collect_refs(text, base):
            rel = os.path.relpath(img_abs, base).replace("\\", "/")
            idx = text.find(rel)
            if idx < 0:
                idx = text.find(os.path.basename(rel))
            heading = heading_at(text, idx) if idx >= 0 else None
            alt_en = nice_caption(alt, heading, img_abs, image_translations)
            entry[img_abs] = alt_en
            lines.append("![%s](%s)" % (alt_en, orig))
        if entry:
            captions[md] = entry
            replacements[md] = lines

    out_dir = os.path.abspath(args.output)
    os.makedirs(out_dir, exist_ok=True)

    md_out = os.path.join(out_dir, "doc_captions.md")
    with open(md_out, "w", encoding="utf-8") as fh:
        fh.write("# English alt-text / captions for documentation images\n\n")
        for md, entry in captions.items():
            fh.write("## `%s`\n\n" % os.path.relpath(md, repo))
            for img, alt in entry.items():
                fh.write("- **`%s`**\n  - Alt-text: `%s`\n" % (os.path.relpath(img, repo), alt))
            fh.write("\n")

    json_out = os.path.join(out_dir, "doc_captions.json")
    json.dump(captions, open(json_out, "w", encoding="utf-8"), ensure_ascii=False, indent=2)

    # Consolidated paste-ready replacement lines (per source doc).
    repl_out = os.path.join(out_dir, "doc_alttext.md")
    with open(repl_out, "w", encoding="utf-8") as fh:
        fh.write("# Paste-ready English image references (replace the Chinese-alt lines in each doc)\n\n")
        for md in sorted(replacements):
            fh.write("## `%s`\n\n" % os.path.relpath(md, repo))
            for line in replacements[md]:
                fh.write(line + "\n")
            fh.write("\n")

    total = sum(len(v) for v in captions.values())
    print(f"Wrote captions for {len(captions)} markdown files / {total} images")
    print(f"  {md_out}")
    print(f"  {json_out}")
    print(f"  {repl_out}")


if __name__ == "__main__":
    main()
