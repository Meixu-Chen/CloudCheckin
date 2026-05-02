#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ENV_FILE="$ROOT_DIR/.env"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing $ENV_FILE"
  echo "Copy .env.local.example to .env, then fill ONEPOINT3ACRES_COOKIE and TWOCAPTCHA_APIKEY."
  exit 1
fi

PYTHON_BIN="${PYTHON_BIN:-python3}"
VENV_DIR="${VENV_DIR:-$ROOT_DIR/.venv}"

if [[ ! -x "$VENV_DIR/bin/python" ]]; then
  "$PYTHON_BIN" -m venv "$VENV_DIR"
  "$VENV_DIR/bin/python" -m pip install --upgrade pip
  "$VENV_DIR/bin/python" -m pip install -r requirements.txt
fi

mkdir -p "$ROOT_DIR/logs"
echo "[$(date '+%F %T %z')] starting 1point3acres checkin"
"$VENV_DIR/bin/python" -m onepoint3acres.onepoint3acres 2>&1 | tee -a "$ROOT_DIR/logs/onepoint3acres.log"
echo "[$(date '+%F %T %z')] finished 1point3acres checkin"
