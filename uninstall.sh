#!/usr/bin/env bash
#
# Guarana uninstaller.
#
#   curl -fsSL https://raw.githubusercontent.com/mrsladoje/guarana/main/uninstall.sh | bash
#
# Stops any running caffeinate, restores normal sleep, and removes the command.

set -euo pipefail

NAME="guarana"
R=$'\033[0m'; B=$'\033[1m'; GR=$'\033[1;32m'; Y=$'\033[1;33m'

info() { echo "${B}==>${R} $*"; }
ok()   { echo "${GR}✓${R} $*"; }

# Restore normal behavior before removing the tool.
if command -v "$NAME" >/dev/null 2>&1; then
  info "Restoring normal sleep settings"
  "$NAME" --kill >/dev/null 2>&1 || true
fi

TARGET="$(command -v "$NAME" 2>/dev/null || true)"
if [[ -z "$TARGET" ]]; then
  echo "${Y}guarana is not installed (not found on PATH).${R}"
  exit 0
fi

SUDO=""
[[ -w "$TARGET" ]] || SUDO="sudo"

info "Removing $TARGET"
$SUDO rm -f "$TARGET"
ok "guarana uninstalled."
