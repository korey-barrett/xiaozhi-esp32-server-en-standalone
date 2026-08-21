#!/bin/bash
# deploy-local-now.sh — runs deploy steps WITHOUT sudo (docker runs as root).
set -euo pipefail

TS=$(date +%Y%m%d-%H%M%S)
DEPLOY=/opt/xiaozhi-server
REPO=/mnt/d/DEV/Projects/xiaozhi-server/xiaozhi-server

echo "=== [1/5] Backup DB data ==="
docker run --rm -v "$DEPLOY:/opt/xiaozhi-server" alpine sh -c \
  "mkdir -p /opt/xiaozhi-server/backup/mysql-$TS && cp -a /opt/xiaozhi-server/mysql/data/. /opt/xiaozhi-server/backup/mysql-$TS/ && echo backup_ok=$TS"
echo "  backed up to $DEPLOY/backup/mysql-$TS"

echo "=== [2/5] Stop the existing (official) stack ==="
docker ps --filter name=xiaozhi-esp32-server --format '{{.Names}}' | xargs -r docker rm -f || true
docker ps --filter name=xiaozhi-esp32-server-web --format '{{.Names}}' | xargs -r docker rm -f || true
docker ps --filter name=xiaozhi-esp32-server-db --format '{{.Names}}' | xargs -r docker rm -f || true
docker ps --filter name=xiaozhi-esp32-server-redis --format '{{.Names}}' | xargs -r docker rm -f || true
echo "  old containers removed"

echo "=== [3/5] Reset MySQL data (so Liquibase re-seeds English) ==="
docker run --rm -v "$DEPLOY:/opt/xiaozhi-server" alpine sh -c "rm -rf /opt/xiaozhi-server/mysql/data && mkdir -p /opt/xiaozhi-server/mysql/data && echo reset_ok"
echo "  mysql data cleared"

echo "=== [4/5] Deploy the English-translated stack ==="
cd "$REPO/main/xiaozhi-server"
docker compose -f docker-compose.local.yml up -d
echo "  stack up"

echo "=== [5/5] Done ==="
docker ps --format 'table {{.Names}}\t{{.Status}}'
echo
echo "Translated stack is deploying. Re-register admin and re-set server.websocket/server.ota in Parameter Management."
echo "DB backup: $DEPLOY/backup/mysql-$TS"
