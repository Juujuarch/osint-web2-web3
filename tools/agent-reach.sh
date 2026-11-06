#!/usr/bin/env bash
# Agent-Reach wrapper for OSINT sweeps.
# Upstream: https://github.com/Panniantong/Agent-Reach (install: uv tool install
# https://github.com/Panniantong/Agent-Reach/releases/latest/download/agent-reach.zip)
# Keyless channels: web (Exa), youtube (yt-dlp), reddit (public), github, bilibili, v2ex
# Login channels: instagram, twitter, reddit site-search, xiaohongshu, linkedin, facebook
#
# Usage:
#   bash tools/agent-reach.sh web <query>     # Exa semantic web search
#   bash tools/agent-reach.sh yt <query>      # YouTube video search
#   bash tools/agent-reach.sh rd <query>      # Reddit public search
#   bash tools/agent-reach.sh ig <username>   # Instagram user search (needs login)
#   bash tools/agent-reach.sh tw <query>      # Twitter search (needs login)
#   bash tools/agent-reach.sh read <url>      # auto-channel page read
#   bash tools/agent-reach.sh channels        # list channel status
set -uo pipefail

if ! command -v agent-reach >/dev/null 2>&1; then
  # uv installs to ~/.local/bin on Windows which may not be on PATH yet
  export PATH="$HOME/.local/bin:$PATH"
fi
if ! command -v agent-reach >/dev/null 2>&1; then
  echo "ERROR: agent-reach not found. Install:"
  echo "  uv tool install https://github.com/Panniantong/Agent-Reach/releases/latest/download/agent-reach.zip"
  echo "  agent-reach setup"
  exit 1
fi

CMD="${1:-}"
[ -n "$CMD" ] || { echo "Usage: bash tools/agent-reach.sh <web|yt|rd|ig|tw|read|channels> <query>"; exit 1; }
shift

case "$CMD" in
  web)      exec agent-reach web search "$@" ;;
  yt)       exec agent-reach youtube search "$@" ;;
  rd)       exec agent-reach reddit search "$@" ;;
  ig)       exec agent-reach instagram search "$@" ;;
  tw)       exec agent-reach twitter search "$@" ;;
  read)     exec agent-reach read "$@" ;;
  channels) exec agent-reach channels ;;
  *) echo "Unknown: $CMD (web|yt|rd|ig|tw|read|channels)"; exit 1 ;;
esac
