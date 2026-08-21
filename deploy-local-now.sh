#!/bin/bash
# deploy-local-now.sh — runs deploy steps WITHOUT sudo (docker runs as root).
#
# This now AUTOMATICALLY backs up your settings/agents before the DB reset and
# re-applies them after the fresh deploy, so you no longer have to re-enter
# server params, model keys, agents, devices, or users by hand.
#
#   ./deploy-local-now.sh            # backup -> reset -> deploy -> restore
#   ./deploy-local-now.sh --no-restore   # skip the automatic restore
set -euo pipefail

TS=$(date +%Y%m%d-%H%M%S)
DEPLOY=/opt/xiaozhi-server
REPO=/mnt/d/DEV/Projects/xiaozhi-esp32-server-en-standalone
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BR="$SCRIPT_DIR/backup-restore.sh"
RESTORE=1
for a in "$@"; do
  [[ "$a" == "--no-restore" ]] && RESTORE=0
done

echo "=== [1/6] Backup settings/agents (SQL) ==="
"$BR" backup predeploy-$TS || echo "  WARNING: SQL backup failed; continuing with raw file backup only."

echo "=== [2/6] Backup raw DB data (belt & suspenders) ==="
docker run --rm -v "$DEPLOY:/opt/xiaozhi-server" alpine sh -c \
  "mkdir -p /opt/xiaozhi-server/backup/mysql-$TS && cp -a /opt/xiaozhi-server/mysql/data/. /opt/xiaozhi-server/backup/mysql-$TS/ && echo backup_ok=$TS"
echo "  backed up to $DEPLOY/backup/mysql-$TS"

echo "=== [3/6] Stop the existing stack ==="
docker ps --filter name=xiaozhi-esp32-server --format '{{.Names}}' | xargs -r docker rm -f || true
docker ps --filter name=xiaozhi-esp32-server-web --format '{{.Names}}' | xargs -r docker rm -f || true
docker ps --filter name=xiaozhi-esp32-server-db --format '{{.Names}}' | xargs -r docker rm -f || true
docker ps --filter name=xiaozhi-esp32-server-redis --format '{{.Names}}' | xargs -r docker rm -f || true
echo "  old containers removed"

echo "=== [4/6] Reset MySQL data (so Liquibase re-seeds English) ==="
docker run --rm -v "$DEPLOY:/opt/xiaozhi-server" alpine sh -c "rm -rf /opt/xiaozhi-server/mysql/data && mkdir -p /opt/xiaozhi-server/mysql/data && echo reset_ok"
echo "  mysql data cleared"

echo "=== [5/6] Deploy the English-translated stack ==="
cd "$REPO/main/xiaozhi-server"
docker compose -f docker-compose.local.yml up -d
echo "  stack up"

if [[ "$RESTORE" == "1" ]]; then
  echo "=== [6/6] Re-apply settings/agents from the latest backup ==="
  LATEST=$(ls -1t "$SCRIPT_DIR/backups"/backup-*-predeploy-*.sql 2>/dev/null | head -n1 || true)
  if [[ -n "$LATEST" ]]; then
    "$BR" restore "$LATEST" || echo "  WARNING: restore failed — re-apply settings manually."
  else
    echo "  No predeploy backup found; skipping restore."
  fi
else
  echo "=== [6/6] Skipping restore (--no-restore) ==="
fi

echo "=== Done ==="
docker ps --format 'table {{.Names}}\t{{.Status}}'
echo
echo "Deploy complete. Settings/agents were restored from the predeploy backup."
echo "Raw DB backup: $DEPLOY/backup/mysql-$TS"
