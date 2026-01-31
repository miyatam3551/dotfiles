#!/usr/bin/env bash

# tmux 環境変数からフラグを取得
SHOW_AWS=$(tmux showenv -g TMUX_SHOW_AWS 2>/dev/null | cut -d= -f2)
SHOW_AZ=$(tmux showenv -g TMUX_SHOW_AZ 2>/dev/null | cut -d= -f2)

[[ "$SHOW_AWS" == "1" ]] && echo -n "AWS:${AWS_PROFILE:-none} "
[[ "$SHOW_AZ" == "1" ]] && echo -n "AZ:$(~/.config/tmux/scripts/azure-sub.sh)"
