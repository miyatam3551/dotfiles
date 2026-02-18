#!/usr/bin/env bash

# mise shims を PATH に追加（非インタラクティブシェルでも az 等を解決するため）
export PATH="$HOME/.local/share/mise/shims:$PATH"

CACHE="$HOME/.cache/tmux-azure-sub"
TTL=10  # 秒

now=$(date +%s)
if [[ -f "$CACHE" ]]; then
  mtime=$(stat -f %m "$CACHE" 2>/dev/null || stat -c %Y "$CACHE")
  if (( now - mtime < TTL )); then
    cat "$CACHE"
    exit 0
  fi
fi

sub=$(az account show \
  --query 'name' \
  --output tsv 2>/dev/null)

echo "${sub:-no-az-login}" | tee "$CACHE"
