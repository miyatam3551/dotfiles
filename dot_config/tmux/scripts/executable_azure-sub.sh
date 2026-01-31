#!/usr/bin/env bash

CACHE="$HOME/.cache/tmux-azure-sub"
TTL=30  # 秒

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
