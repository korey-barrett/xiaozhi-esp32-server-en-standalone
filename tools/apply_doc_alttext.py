#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
apply_doc_alttext.py
====================
Apply the generated English alt-texts to the repo's Markdown docs in place.

For every Markdown file (README.md and docs/**/*.md), it finds each `![alt](path)`
reference and replaces the alt with the English alt-text computed from the
section heading + the extracted image translations. Image paths and titles are
preserved unchanged.

Backup: files are tracked by git, so `git checkout -- <file>` restores them.

Usage:
    python tools/apply_doc_alttext.py [--dry-run] [--report images_report.json]
"""

import argparse
import glob
import importlib.util
import json
import os
import re
import sys

GDC = "generate_doc_captions.py"


def load_gdc():
    spec = importlib.util.spec_from_file_location("gdc", os.path.join(os.path.dirname(os.path.abspath(__file__)), GDC))
    gdc = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(gdc)
    return gdc


def main():
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")

    ap = __import__("argparse").ArgumentParser(description=__doc__)
    ap.add_argument("--dry-run", action="store_true", help="report changes without writing")
    ap.add_argument("--report", default="docs_images_en/images_report.json")
    args = ap.parse_args()

    gdc = load_gdc()
    repo = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
    if not os.path.isfile(args.report):
        print(f"[error] report not found: {args.report}")
        sys.exit(2)
    report = json.load(open(args.report, encoding="utf-8"))

    md_files = set()
    for pat in ("README.md", "docs/**/*.md"):
        md_files.update(glob.glob(os.path.join(repo, pat), recursive=True))
    md_files = sorted(md_files)

    total_changed = 0
    for md in md_files:
        text = open(md, encoding="utf-8").read()
        base = os.path.dirname(md)
        changed = 0

        def repl(m):
            nonlocal changed
            alt = m.group(1).strip()
            target = m.group(2).strip()
            parts = target.split(None, 1)
            path = parts[0]
            if not gdc.is_local(path):
                return m.group(0)
            img_abs = os.path.normpath(os.path.join(base, path))
            heading = gdc.heading_at(text, m.start())
            # Strip any previously-applied caption suffix so re-runs are idempotent.
            alt_clean = re.sub(r"\s*[—–\-]\s*UI text shown:.*$", "", alt)
            alt_en = gdc.nice_caption(alt_clean, heading, img_abs, report)
            changed += 1
            return "![%s](%s)" % (alt_en, target)

        new_text = gdc.MD_IMAGE.sub(repl, text)
        if changed:
            if not args.dry_run:
                open(md, "w", encoding="utf-8").write(new_text)
            print(f"{'[dry-run] ' if args.dry_run else '[applied] '}{os.path.relpath(md, repo)}  ({changed} refs)")

    print("Dry-run complete (no files written)." if args.dry_run else "Done applying alt-texts.")


if __name__ == "__main__":
    main()
