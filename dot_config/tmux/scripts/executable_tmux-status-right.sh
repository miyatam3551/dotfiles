#!/usr/bin/env bash

# フラグを取得（優先順位: 1. tmux環境変数 → 2. ペインディレクトリの.env）
get_flag() {
    local value
    # 1. tmux グローバル環境変数をチェック
    value=$(tmux showenv -g "$1" 2>/dev/null | cut -d= -f2)
    if [[ -n "$value" ]]; then echo "$value"; return; fi

    # 2. アクティブペインのディレクトリの .tmuxenv をチェック
    local pane_path
    pane_path=$(tmux display-message -p '#{pane_current_path}' 2>/dev/null)
    if [[ -n "$pane_path" && -f "$pane_path/.tmuxenv" ]]; then
        value=$(grep "^$1=" "$pane_path/.tmuxenv" 2>/dev/null | cut -d= -f2)
        if [[ -n "$value" ]]; then echo "$value"; return; fi
    fi

    echo "0"
}

SHOW_AWS=$(get_flag TMUX_SHOW_AWS)
SHOW_AZ=$(get_flag TMUX_SHOW_AZ)
SHOW_CPU_RAM=$(get_flag TMUX_SHOW_CPU_RAM)
SHOW_BATTERY=$(get_flag TMUX_SHOW_BATTERY)
SHOW_HOST=$(get_flag TMUX_SHOW_HOST)
SHOW_CLOCK=$(get_flag TMUX_SHOW_CLOCK)

# 色定義（Catppuccin Mocha）
CLR_CLOUD="#f9e2af"
CLR_SEP="#45475a"
CLR_TEXT="#7f849c"

# 区切り線を追加するヘルパー
add_separator() {
    [[ -n "$output" ]] && output+="#[fg=${CLR_SEP}]│ "
}

output=""

# 1. クラウド情報
if [[ "$SHOW_AWS" == "1" ]]; then
    output+="#[fg=${CLR_CLOUD}]AWS:${AWS_PROFILE:-none} "
fi
if [[ "$SHOW_AZ" == "1" ]]; then
    output+="#[fg=${CLR_CLOUD}]AZ:$(~/.config/tmux/scripts/azure-sub.sh) "
fi

# 2. CPU/RAM
if [[ "$SHOW_CPU_RAM" == "1" ]]; then
    get_cpu() {
        local cpu_sum cores
        cpu_sum=$(ps -A -o %cpu | awk '{sum+=$1} END {print sum}')
        cores=$(sysctl -n hw.ncpu)
        awk "BEGIN {printf \"%2.0f%%\", $cpu_sum / $cores}"
    }
    get_ram() {
        local total_bytes page_size pages_anon pages_wired pages_compressed used_bytes used_percent
        total_bytes=$(sysctl -n hw.memsize)
        page_size=$(sysctl -n hw.pagesize)
        eval "$(vm_stat | awk -F: '
            /Anonymous pages/             { gsub(/[^0-9]/, "", $2); print "pages_anon=" $2 }
            /Pages wired/                 { gsub(/[^0-9]/, "", $2); print "pages_wired=" $2 }
            /Pages occupied by compressor/ { gsub(/[^0-9]/, "", $2); print "pages_compressed=" $2 }
        ')"
        used_bytes=$(( (pages_anon + pages_wired + pages_compressed) * page_size ))
        used_percent=$(( used_bytes * 100 / total_bytes ))
        printf "%2d%%" "$used_percent"
    }

    add_separator
    output+="#[fg=${CLR_TEXT}]CPU:$(get_cpu) RAM:$(get_ram) "
fi

# 3. バッテリー
if [[ "$SHOW_BATTERY" == "1" ]]; then
    get_battery_status() {
        local batt_info percent status_icon
        batt_info=$(pmset -g batt 2>/dev/null | tail -1)
        percent=$(echo "$batt_info" | grep -oE '[0-9]+%')

        if echo "$batt_info" | grep -q 'charging'; then
            status_icon="CHG"
        elif echo "$batt_info" | grep -q 'discharging'; then
            status_icon="BAT"
        else
            status_icon="AC"
        fi
        echo "${status_icon} ${percent}"
    }

    add_separator
    output+="#[fg=${CLR_TEXT}]$(get_battery_status) "
fi

# 4. ホスト名
if [[ "$SHOW_HOST" == "1" ]]; then
    add_separator
    output+="#[fg=${CLR_TEXT}]$(hostname -s) "
fi

# 5. 時計
if [[ "$SHOW_CLOCK" == "1" ]]; then
    add_separator
    output+="#[fg=${CLR_TEXT}]$(date '+%-m/%-d(%a) %-H:%M') "
fi

echo -n "$output"
