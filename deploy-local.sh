#!/bin/bash
# ============================================================
# Deploy the ENGLISH-TRANSLATED xiaozhi-esp32-server locally
#
# Strategy (the "lighter" approach):
#  - Build `server` (app layer) and `web` (Vue+Java) images from the
#    translated repo, tagged xiaozhi-local:* .
#  - Run them from the EXISTING /opt/xiaozhi-server deploy directory,
#    so the model, data, and config stay in place.
#  - Back up the current DB, reset mysql data, then redeploy so Liquibase
#    re-seeds from the translated (English) changelogs.
#
# Run with:  sudo bash deploy-local.sh
# ============================================================

set -euo pipefail

# ----- configurable paths -----
REPO="/mnt/d/DEV/Projects/xiaozhi-server/xiaozhi-server"   # translated repo
DEPLOY="/opt/xiaozhi-server"                                # existing live deploy
TS="$(date +%Y%m%d-%H%M%S)"

echo "==================================================="
echo " xiaozhi ENGLISH deploy  (lighter approach)"
echo "==================================================="
echo "repo  : $REPO"
echo "deploy: $DEPLOY"
echo "time  : $TS"
echo

echo "[1/7] Build server-base image (own base, no upstream dependency) ..."
cd "$REPO"
docker build -f Dockerfile-server-base -t xiaozhi-local:server-base .

echo "[2/7] Build server image from translated repo ..."
docker build -f Dockerfile-server -t xiaozhi-local:server_latest .

echo "[3/7] Build web image from translated repo ..."
docker build -f Dockerfile-web -t xiaozhi-local:web_latest .

echo "[4/7] Backup current DB data ..."
mkdir -p "$DEPLOY/backup/mysql-$TS"
cp -a "$DEPLOY/mysql/data/." "$DEPLOY/backup/mysql-$TS/" 2>/dev/null || true
echo "  DB backed up to $DEPLOY/backup/mysql-$TS"

echo "[5/7] Stop the existing stack ..."
cd "$DEPLOY"
docker-compose -f docker-compose_all.yml down || true

echo "[6/7] Reset mysql data so Liquibase re-seeds English changelogs ..."
rm -rf "$DEPLOY/mysql/data"
mkdir -p "$DEPLOY/mysql/data"
echo "  mysql data cleared"

echo "[7/7] Deploy the translated stack ..."
docker-compose -f docker-compose_all.yml up -d
echo "  (compose uses the locally-built xiaozhi-local images)"

echo
echo "==================================================="
echo " DONE. Translated stack is deploying."
echo " Console: http://<LAN-IP>:8002  (re-register admin;"
echo " re-set server.websocket and server.ota in Parameter Management)"
echo " To revert to official images: restore docker-compose_all.yml.bak-$TS"
echo "==================================================="
