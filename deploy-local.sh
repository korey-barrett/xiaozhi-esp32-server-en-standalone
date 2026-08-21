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

echo "[1/6] Build server image from translated repo ..."
cd "$REPO"
docker build -f Dockerfile-server -t xiaozhi-local:server_latest .

echo "[2/6] Build web image from translated repo ..."
docker build -f Dockerfile-web -t xiaozhi-local:web_latest .

echo "[3/6] Backup current DB data ..."
mkdir -p "$DEPLOY/backup/mysql-$TS"
cp -a "$DEPLOY/mysql/data/." "$DEPLOY/backup/mysql-$TS/" 2>/dev/null || true
echo "  DB backed up to $DEPLOY/backup/mysql-$TS"

echo "[4/6] Stop the existing stack ..."
cd "$DEPLOY"
docker-compose -f docker-compose_all.yml down || true

echo "[5/6] Reset mysql data so Liquibase re-seeds English changelogs ..."
rm -rf "$DEPLOY/mysql/data"
mkdir -p "$DEPLOY/mysql/data"
echo "  mysql data cleared"

echo "[6/6] Deploy the translated stack ..."
# Temporarily point compose at the local images, then restore.
cp docker-compose_all.yml docker-compose_all.yml.bak-$TS
sed -i \
  -e 's#ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest#xiaozhi-local:server_latest#g' \
  -e 's#ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:web_latest#xiaozhi-local:web_latest#g' \
  docker-compose_all.yml
docker-compose -f docker-compose_all.yml up -d
echo "  (compose image refs temporarily switched to xiaozhi-local; original saved as docker-compose_all.yml.bak-$TS)"

echo
echo "==================================================="
echo " DONE. Translated stack is deploying."
echo " Console: http://<LAN-IP>:8002  (re-register admin;"
echo " re-set server.websocket and server.ota in Parameter Management)"
echo " To revert to official images: restore docker-compose_all.yml.bak-$TS"
echo "==================================================="
