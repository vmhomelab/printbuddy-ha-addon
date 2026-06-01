#!/bin/sh
set -eu

OPTIONS_FILE=/data/options.json

read_option() {
    key="$1"
    default="$2"
    python3 - "$OPTIONS_FILE" "$key" "$default" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
key = sys.argv[2]
default = sys.argv[3]
try:
    data = json.loads(path.read_text()) if path.exists() else {}
except Exception:
    data = {}
value = data.get(key, default)
if isinstance(value, bool):
    print("true" if value else "false")
else:
    print(value)
PY
}

LOG_LEVEL_VALUE="$(read_option log_level info)"
PUID_VALUE="$(read_option puid 1000)"
PGID_VALUE="$(read_option pgid 1000)"
USE_SYSTEM_TRUST_STORE_VALUE="$(read_option use_system_trust_store false)"
TRUSTED_FRAME_ORIGINS_VALUE="$(read_option trusted_frame_origins http://homeassistant.local:8123)"

export DATA_DIR="${DATA_DIR:-/data/printbuddy}"
export LOG_DIR="${LOG_DIR:-/data/logs}"
export PORT="${PORT:-8000}"
export LOG_LEVEL="$(printf '%s' "$LOG_LEVEL_VALUE" | tr '[:lower:]' '[:upper:]')"
export PUID="$PUID_VALUE"
export PGID="$PGID_VALUE"

if [ -n "$TRUSTED_FRAME_ORIGINS_VALUE" ]; then
    export TRUSTED_FRAME_ORIGINS="$TRUSTED_FRAME_ORIGINS_VALUE"
fi

mkdir -p \
    "$DATA_DIR" \
    "$DATA_DIR/archive" \
    "$DATA_DIR/plate_calibration" \
    "$LOG_DIR"

if [ "$(id -u)" -eq 0 ]; then
    echo "[printbuddy-addon] chown -R ${PUID}:${PGID} ${DATA_DIR} ${LOG_DIR}"
    chown -R "${PUID}:${PGID}" "$DATA_DIR" "$LOG_DIR" || true
fi

if [ "$USE_SYSTEM_TRUST_STORE_VALUE" = "true" ]; then
    if find /ssl -maxdepth 1 -type f -name '*.crt' 2>/dev/null | grep -q .; then
        mkdir -p /usr/local/share/ca-certificates/homeassistant
        cp /ssl/*.crt /usr/local/share/ca-certificates/homeassistant/ 2>/dev/null || true
        export USE_SYSTEM_TRUST_STORE=1
    else
        echo "[printbuddy-addon] use_system_trust_store=true but no /ssl/*.crt files were found; continuing without custom CA import"
    fi
fi

exec /usr/local/bin/docker-entrypoint.sh \
    uvicorn backend.app.main:app \
    --host 0.0.0.0 \
    --port "$PORT" \
    --loop asyncio
