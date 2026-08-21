#!/usr/bin/env python3
"""Surgically update `manager-api.secret` in the xiaozhi `.config.yaml` file.

The Python server authenticates to the Java manager-api using this secret, and it
must match the `server.secret` value stored in the `sys_params` table. After a
database restore this file is re-synced so the two stay in agreement.

Only the `secret:` line under the `manager-api:` block is touched; the rest of
the file is preserved byte-for-byte (including any unicode escapes).

Usage:
    python sync_manager_secret.py --config <path> --secret <value>
"""

import argparse
import re
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", required=True, help="Path to .config.yaml")
    parser.add_argument("--secret", required=True, help="New manager-api.secret value")
    args = parser.parse_args()

    with open(args.config, "r", encoding="utf-8") as fh:
        lines = fh.readlines()

    in_manager = False
    done = False
    for i, line in enumerate(lines):
        if re.match(r"^manager-api:\s*$", line):
            in_manager = True
            continue
        # A new top-level key ends the manager-api block.
        if in_manager and re.match(r"^\S", line):
            in_manager = False
        if in_manager and re.match(r"^\s+secret:", line):
            indent = line[: len(line) - len(line.lstrip())]
            lines[i] = f"{indent}secret: {args.secret}\n"
            done = True
            break

    if not done:
        print(
            "ERROR: could not find manager-api.secret in %s" % args.config,
            file=sys.stderr,
        )
        return 1

    with open(args.config, "w", encoding="utf-8") as fh:
        fh.writelines(lines)

    print("manager-api.secret updated to %s" % args.secret)
    return 0


if __name__ == "__main__":
    sys.exit(main())
