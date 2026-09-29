#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./install.sh [--target DIR]

Install this repository's LazyVim configuration. The default destination is:
  $NVIM_CONFIG_DIR, when set; otherwise
  $XDG_CONFIG_HOME/nvim, when set; otherwise
  $HOME/.config/nvim

An existing destination is moved to a timestamped sibling backup first.
EOF
}

TARGET_DIR="${NVIM_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/nvim}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      shift
      [ "$#" -gt 0 ] || { echo "ERROR: --target requires a directory" >&2; exit 2; }
      TARGET_DIR="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown option: $1" >&2
      echo >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/nvim"

[ -d "$SOURCE_DIR" ] || { echo "ERROR: missing config directory: $SOURCE_DIR" >&2; exit 1; }
[ -n "$TARGET_DIR" ] || { echo "ERROR: target directory cannot be empty" >&2; exit 1; }

# Avoid moving the repository out from under a user who cloned it directly to
# ~/.config/nvim. Clone elsewhere and let this script install the config.
if [ "$(realpath -m "$TARGET_DIR")" = "$(realpath -m "$SCRIPT_DIR")" ]; then
  echo "ERROR: the repository itself is at the target path: $TARGET_DIR" >&2
  echo "       Clone it elsewhere, then run install.sh again." >&2
  exit 1
fi

TARGET_PARENT="$(dirname "$TARGET_DIR")"
mkdir -p "$TARGET_PARENT"

STAGE_DIR="$(mktemp -d "$TARGET_PARENT/.nvim-install.XXXXXX")"
BACKUP_DIR=""
INSTALLED=0

cleanup() {
  [ -z "$STAGE_DIR" ] || rm -rf "$STAGE_DIR"

  # If replacement failed after the old config was moved, restore it.
  if [ "$INSTALLED" -eq 0 ] && [ -n "$BACKUP_DIR" ] \
      && [ ! -e "$TARGET_DIR" ] && [ ! -L "$TARGET_DIR" ]; then
    mv "$BACKUP_DIR" "$TARGET_DIR"
    echo "Restored the previous config after an installation error." >&2
  fi
}
trap cleanup EXIT

cp -a "$SOURCE_DIR/." "$STAGE_DIR/"

if [ -e "$TARGET_DIR" ] || [ -L "$TARGET_DIR" ]; then
  timestamp="$(date +%Y%m%d-%H%M%S)"
  BACKUP_DIR="${TARGET_DIR}.backup.${timestamp}"
  suffix=1
  while [ -e "$BACKUP_DIR" ] || [ -L "$BACKUP_DIR" ]; do
    BACKUP_DIR="${TARGET_DIR}.backup.${timestamp}.${suffix}"
    suffix=$((suffix + 1))
  done

  mv "$TARGET_DIR" "$BACKUP_DIR"
fi

mv "$STAGE_DIR" "$TARGET_DIR"
STAGE_DIR=""
INSTALLED=1
trap - EXIT

printf 'Installed LazyVim config to %s\n' "$TARGET_DIR"
if [ -n "$BACKUP_DIR" ]; then
  printf 'Previous config backed up to %s\n' "$BACKUP_DIR"
fi
printf 'Run nvim to install/sync plugins and Mason tools.\n'
