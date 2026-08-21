#!/bin/bash
# =============================================================================
# backup-restore.sh — backup & restore xiaozhi settings, agents, users, devices
#
# The admin console stores ALL of your configuration (server params, model
# providers/configs, agents, devices, users, etc.) in the MySQL database. A
# fresh deploy wipes that database, so every setting and agent has to be
# re-applied by hand. This script makes that a one-liner:
#
#   ./backup-restore.sh backup                 # dump config/agent tables to backups/
#   ./backup-restore.sh restore <file.sql>     # re-import after a fresh deploy
#   ./backup-restore.sh list                   # show available backups
#   ./backup-restore.sh secret                 # show DB vs config secret (diagnostic)
#
# Run inside WSL2 (where docker is available). After `restore`, the script also
# re-syncs the Python server's `manager-api.secret` to match the restored DB
# value, so the two stay in agreement.
#
# Typical fresh-deploy flow:
#   1. ./backup-restore.sh backup
#   2. bash deploy-local-now.sh            # wipes + re-seeds the DB
#   3. ./backup-restore.sh restore backups/backup-<TS>.sql
# =============================================================================
set -euo pipefail

# ---- configurable (override via env) --------------------------------------
DB_CONTAINER="${DB_CONTAINER:-xiaozhi-esp32-server-db}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-123456}"
DB_NAME="${DB_NAME:-xiaozhi_esp32_server}"
DEPLOY="${DEPLOY:-/opt/xiaozhi-server}"
SERVER_IMAGE="${SERVER_IMAGE:-xiaozhi-local:server_latest}"
CONFIG_FILE="${CONFIG_FILE:-$DEPLOY/data/.config.yaml}"
SYNC_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/tools/sync_manager_secret.py"

# Backups are stored next to this script in ./backups
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$SCRIPT_DIR/backups}"

# Tables to back up. Chat history / session tokens are intentionally excluded
# (large, and not needed to re-apply configuration).
TABLES=(
  # --- settings / config ---
  sys_params
  ai_model_provider
  ai_model_config
  ai_tts_voice
  ai_ota
  sys_dict_type
  sys_dict_data
  # --- agents ---
  ai_agent
  ai_agent_template
  ai_agent_plugin_mapping
  ai_agent_tag
  ai_agent_tag_relation
  ai_agent_snapshot
  ai_agent_context_provider
  ai_agent_correct_word_file
  ai_agent_correct_word_item
  ai_agent_correct_word_mapping
  # --- users ---
  sys_user
  sys_user_oauth
  # --- devices ---
  ai_device
  ai_agent_voice_print
  ai_device_address_book
  # --- user data (voice clones / RAG knowledge) ---
  ai_voice_clone
  ai_rag_dataset
  ai_rag_knowledge_document
)

# ---------------------------------------------------------------------------
usage() {
  sed -n '2,30p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  echo
  echo "Commands:"
  echo "  backup [label]        Dump config/agent tables to backups/backup-<TS>[-label].sql"
  echo "  restore <file.sql>    Re-import a backup after a fresh deploy (and re-sync secret)"
  echo "  list                  List available backups"
  echo "  secret                Show DB server.secret vs config manager-api.secret"
  echo
  echo "Options:"
  echo "  --skip-secret-sync    With restore: do not re-sync the config secret"
}

# ---------------------------------------------------------------------------
db_ready() {
  docker exec "$DB_CONTAINER" mysqladmin ping -h localhost -u"$DB_USER" -p"$DB_PASS" >/dev/null 2>&1
}

wait_for_db() {
  echo "Waiting for DB container to be ready..."
  for _ in $(seq 1 60); do
    if db_ready; then
      echo "  DB is up."
      return 0
    fi
    sleep 2
  done
  echo "ERROR: DB container not ready after 120s." >&2
  return 1
}

# ---------------------------------------------------------------------------
cmd_backup() {
  local label="${1:-}"
  mkdir -p "$BACKUP_DIR"
  local ts; ts="$(date +%Y%m%d-%H%M%S)"
  local out="$BACKUP_DIR/backup-$ts${label:+-$label}.sql"

  wait_for_db

  echo "Backing up ${#TABLES[@]} tables to: $out"
  docker exec "$DB_CONTAINER" sh -c \
    "mysqldump -u$DB_USER -p$DB_PASS --no-create-info --replace --single-transaction --set-gtid-purged=OFF $DB_NAME ${TABLES[*]}" \
    > "$out" 2>/dev/null

  # Sanity check: the file should contain REPLACE INTO statements.
  if ! grep -q "REPLACE INTO" "$out"; then
    echo "ERROR: backup appears empty/invalid (no REPLACE INTO found)." >&2
    rm -f "$out"
    return 1
  fi

  local size; size="$(du -h "$out" | cut -f1)"
  echo "Backup OK: $out ($size)"
  echo
  echo "To restore after a fresh deploy:"
  echo "  ./backup-restore.sh restore $out"
}

# ---------------------------------------------------------------------------
cmd_restore() {
  local file="${1:-}"
  local skip_sync="${2:-0}"

  if [[ -z "$file" ]]; then
    echo "ERROR: restore requires a backup file." >&2
    usage
    return 1
  fi
  if [[ ! -f "$file" ]]; then
    echo "ERROR: backup file not found: $file" >&2
    return 1
  fi

  wait_for_db

  # Make sure the tables exist (Liquibase must have finished seeding).
  local missing
  missing="$(docker exec "$DB_CONTAINER" mysql -u"$DB_USER" -p"$DB_PASS" -N -e \
    "SELECT table_name FROM information_schema.tables WHERE table_schema='$DB_NAME' AND table_name IN ('sys_params','ai_agent');" 2>/dev/null)"
  if [[ "$missing" != *"sys_params"* || "$missing" != *"ai_agent"* ]]; then
    echo "ERROR: expected tables not present yet. Is the web container up and Liquibase finished?" >&2
    echo "  Found: $missing" >&2
    return 1
  fi

  echo "Restoring from: $file"
  docker exec -i "$DB_CONTAINER" sh -c "mysql -u$DB_USER -p$DB_PASS $DB_NAME" < "$file"
  echo "  Database restored."

  if [[ "$skip_sync" == "1" ]]; then
    echo "  Skipping config secret sync (--skip-secret-sync)."
    return 0
  fi

  sync_secret
}

# ---------------------------------------------------------------------------
sync_secret() {
  echo "Re-syncing config manager-api.secret to match the restored DB..."
  local secret
  secret="$(docker exec "$DB_CONTAINER" mysql -u"$DB_USER" -p"$DB_PASS" -N -e \
    "SELECT param_value FROM $DB_NAME.sys_params WHERE param_code='server.secret';" 2>/dev/null | tr -d '\r')"
  if [[ -z "$secret" ]]; then
    echo "ERROR: could not read server.secret from the DB." >&2
    return 1
  fi

  if [[ ! -f "$SYNC_SCRIPT" ]]; then
    echo "ERROR: sync script not found: $SYNC_SCRIPT" >&2
    return 1
  fi

  # Write the config file via a container (the /opt deploy dir is root-owned).
  docker run --rm -i -v "$DEPLOY:/opt/xiaozhi-server" "$SERVER_IMAGE" \
    python - --config /opt/xiaozhi-server/data/.config.yaml --secret "$secret" \
    < "$SYNC_SCRIPT"
  echo "  Config secret synced to: $secret"
}

# ---------------------------------------------------------------------------
cmd_list() {
  mkdir -p "$BACKUP_DIR"
  if [[ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
    echo "No backups found in $BACKUP_DIR"
    return 0
  fi
  echo "Backups in $BACKUP_DIR:"
  ls -lht "$BACKUP_DIR" | awk 'NR>1 {print $5"\t"$9}'
}

# ---------------------------------------------------------------------------
cmd_secret() {
  wait_for_db
  local db_secret cfg_secret
  db_secret="$(docker exec "$DB_CONTAINER" mysql -u"$DB_USER" -p"$DB_PASS" -N -e \
    "SELECT param_value FROM $DB_NAME.sys_params WHERE param_code='server.secret';" 2>/dev/null | tr -d '\r')"
  cfg_secret="$(docker run --rm -v "$DEPLOY:/opt/xiaozhi-server" "$SERVER_IMAGE" \
    python -c "import yaml,sys; print(yaml.safe_load(open('/opt/xiaozhi-server/data/.config.yaml'))['manager-api']['secret'])" 2>/dev/null || echo "<unreadable>")"
  echo "DB    server.secret : $db_secret"
  echo "Config manager-api  : $cfg_secret"
  if [[ -n "$db_secret" && "$db_secret" == "$cfg_secret" ]]; then
    echo "MATCH: OK"
  else
    echo "MISMATCH: run './backup-restore.sh restore <file>' or sync manually."
  fi
}

# ---------------------------------------------------------------------------
main() {
  local cmd="${1:-}"
  shift || true
  case "$cmd" in
    backup)  cmd_backup "${1:-}" ;;
    restore)
      local skip=0
      local file=""
      for a in "$@"; do
        if [[ "$a" == "--skip-secret-sync" ]]; then skip=1; else file="$a"; fi
      done
      cmd_restore "$file" "$skip"
      ;;
    list)    cmd_list ;;
    secret)  cmd_secret ;;
    ""|-h|--help|help) usage ;;
    *) echo "Unknown command: $cmd" >&2; usage; return 1 ;;
  esac
}

main "$@"
