#!/usr/bin/env bash

# tmux 環境変数からフラグを取得（デフォルト: 1=表示）
get_flag() {
    local value
    value=$(tmux showenv -g "$1" 2>/dev/null | cut -d= -f2)
    echo "${value:-1}"
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
        ps -A -o %cpu | awk '{sum+=$1} END {printf "%2.0f%%", sum}'
    }
    get_ram() {
        local pages_free pages_active pages_inactive pages_speculative pages_wired page_size total_pages used_percent
        eval "$(vm_stat | awk -F: '
            /Pages free/      { gsub(/[^0-9]/, "", $2); print "pages_free=" $2 }
            /Pages active/    { gsub(/[^0-9]/, "", $2); print "pages_active=" $2 }
            /Pages inactive/  { gsub(/[^0-9]/, "", $2); print "pages_inactive=" $2 }
            /Pages speculative/ { gsub(/[^0-9]/, "", $2); print "pages_speculative=" $2 }
            /Pages wired/     { gsub(/[^0-9]/, "", $2); print "pages_wired=" $2 }
        ')"
        total_pages=$((pages_free + pages_active + pages_inactive + pages_speculative + pages_wired))
        used_percent=$(( (pages_active + pages_wired) * 100 / total_pages ))
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
