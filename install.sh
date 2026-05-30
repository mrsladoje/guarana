#!/usr/bin/env bash
#
# Guarana installer.
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/mrsladoje/guarana/main/install.sh | bash
#
# Installs the `guarana` command to /usr/local/bin (on the default macOS PATH),
# so `guarana` and `guarana --kill` work from any shell.

set -euo pipefail

REPO="mrsladoje/guarana"
BRANCH="main"
NAME="guarana"
RAW_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/${NAME}"
INSTALL_DIR="/usr/local/bin"

# ── colors ──────────────────────────────────────────────────────────────────
R=$'\033[0m'; B=$'\033[1m'; GR=$'\033[1;32m'; Y=$'\033[1;33m'; RD=$'\033[1;31m'

info()  { echo "${B}==>${R} $*"; }
ok()    { echo "${GR}✓${R} $*"; }
warn()  { echo "${Y}!${R} $*"; }
die()   { echo "${RD}✗ $*${R}" >&2; exit 1; }

# ── platform guard ──────────────────────────────────────────────────────────
[[ "$(uname -s)" == "Darwin" ]] || die "Guarana only works on macOS (it uses caffeinate + pmset)."

# ── locate the source script (local checkout if present, otherwise download) ─
SRC=""
CLEANUP=""
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"

if [[ -n "$SELF_DIR" && -f "$SELF_DIR/$NAME" ]]; then
  SRC="$SELF_DIR/$NAME"
  info "Installing from local checkout: $SRC"
else
  command -v curl >/dev/null 2>&1 || die "curl is required but not found."
  SRC="$(mktemp -t guarana)"
  CLEANUP="$SRC"
  info "Downloading guarana from $RAW_URL"
  curl -fsSL "$RAW_URL" -o "$SRC" || die "Download failed."
fi

# ── pick a writable install dir + decide whether sudo is needed ─────────────
SUDO=""
if [[ ! -d "$INSTALL_DIR" ]]; then
  mkdir -p "$INSTALL_DIR" 2>/dev/null || SUDO="sudo"
fi
if [[ -n "$SUDO" || ! -w "$INSTALL_DIR" ]]; then
  SUDO="sudo"
  warn "$INSTALL_DIR needs elevated permissions — you may be prompted for your password."
fi

[[ -n "$SUDO" ]] && $SUDO mkdir -p "$INSTALL_DIR"

# ── install ─────────────────────────────────────────────────────────────────
info "Installing to $INSTALL_DIR/$NAME"
$SUDO install -m 0755 "$SRC" "$INSTALL_DIR/$NAME" || die "Install failed."
[[ -n "$CLEANUP" ]] && rm -f "$CLEANUP"

ok "Installed guarana to $INSTALL_DIR/$NAME"

# ── PATH sanity check ───────────────────────────────────────────────────────
if ! command -v guarana >/dev/null 2>&1; then
  case ":$PATH:" in
    *":$INSTALL_DIR:"*) ;;
    *) warn "$INSTALL_DIR is not on your PATH. Add this to your shell config:"
       echo "    export PATH=\"$INSTALL_DIR:\$PATH\"" ;;
  esac
fi

echo ""
ok "Done! Try it:"
echo "    ${B}guarana${R}          keep your Mac awake (safe to close the lid)"
echo "    ${B}guarana --kill${R}   go back to normal sleep"
echo ""
