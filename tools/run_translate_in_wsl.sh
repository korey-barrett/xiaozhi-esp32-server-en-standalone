#!/usr/bin/env bash
# ============================================================
# run_translate_in_wsl.sh
# WSL-friendly wrapper around tools/translate_screenshots.py
#
# Usage (from WSL):
#   bash tools/run_translate_in_wsl.sh ./screenshots ./screenshots_en --json
#
# Notes:
#   - Uses the repo mounted at /mnt/d in WSL (matches the deployment setup).
#   - Uses python3 inside WSL if present, else the Windows python.exe via interop.
#   - Ollama is reached at OLLAMA_HOST (default http://127.0.0.1:11434). If Ollama
#     runs on the Windows host in NAT mode, WSL reaches it via the host IP:
#         export OLLAMA_HOST="http://$(ip route show default | awk '{print $3}'):11434"
#     (In WSL2 NAT, 127.0.0.1 inside WSL is the WSL VM, not the Windows host.)
# ============================================================

set -euo pipefail

REPO="/mnt/d/DEV/Projects/xiaozhi-server/xiaozhi-server"

# cd into the repo wherever the script lives (script may be in the repo already)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$SCRIPT_DIR/../main" ]; then
  REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
fi
cd "$REPO"

# Pick a python interpreter: prefer python3 in WSL, else Windows python interop.
PY=""
for cand in python3 python; do
  if command -v "$cand" >/dev/null 2>&1; then PY="$cand"; break; fi
done
if [ -z "$PY" ]; then
  echo "No python3/python found in WSL. Install it:  sudo apt-get install -y python3"
  exit 1
fi

echo "REPO : $REPO"
echo "PYTHON: $PY"
echo "Running: $PY tools/translate_screenshots.py $*"
echo
"$PY" tools/translate_screenshots.py "$@"
