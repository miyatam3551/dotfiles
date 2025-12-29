# config.nu

# ===============================================
# モジュールのインポート / Import Modules
# ===============================================
use ~/.config/nushell/modules/functions.nu *
use ~/.config/nushell/modules/ghq.nu *
use ~/.config/nushell/modules/aliases.nu *

# ===============================================
# 基本設定 / Basic Configuration
# ===============================================

# 既存の設定を保持しつつ、マージする形で設定を追加
$env.config = ($env.config? | default {} | merge {
    edit_mode: "vi"              # vi-mode有効化
    show_banner: false           # ウェルカムメッセージ無効化

    # 履歴設定
    history: {
        max_size: 100000
        sync_on_enter: true
        file_format: "sqlite"
    }

    # テーブル表示
    table: {
        mode: "rounded"
    }

    # キーバインディング設定
    keybindings: [
        {
            name: abbr
            modifier: control
            keycode: space
            mode: [emacs, vi_normal, vi_insert]
            event: [
                { send: menu name: abbr_menu }
                { edit: insertchar, value: ' '}
            ]
        }
    ]

    # メニュー設定
    menus: [
        {
            name: abbr_menu
            only_buffer_difference: false
            marker: "👀 "
            type: {
                layout: columnar
                columns: 1
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
            source: { |buffer, position|
                scope aliases
                | where name == $buffer
                | each { |elt| {value: $elt.expansion }}
            }
        }
    ]

    # カラー設定 (テーブル表示時の着色)
    # https://www.nushell.sh/blog/2024-05-15-top-nushell-hacks.html
    color_config: {
        string: {|| if $in =~ '^#[a-fA-F\d]+' { $in } else { 'default' } }
    }
})

# ===============================================
# Starship プロンプト / Starship Prompt
# https://starship.rs/#nushell
# ===============================================

let starship_cache = ($nu.data-dir | path join "vendor/autoload/starship.nu")
if not ($starship_cache | path exists) {
    mkdir ($nu.data-dir | path join "vendor/autoload")
    starship init nu | save -f $starship_cache
}

# ===============================================
# zoxide 設定(z の代替)
# https://github.com/ajeetdsouza/zoxide
# ===============================================

if not ('~/.config/zoxide/init.nu' | path exists) {
    mkdir ~/.config/zoxide
    zoxide init nushell | save ~/.config/zoxide/init.nu
}
source ~/.config/zoxide/init.nu

# ===============================================
# direnv の設定
# https://www.nushell.sh/cookbook/direnv.html#configuring-direnv
# ===============================================

$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt?
    | default []
    | append {||
        if (which direnv | is-empty) {
            return
        }

        direnv export json | from json | default {} | load-env
        if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
            $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
        }
    }
)

# ===============================================
# cd 履歴の記録
# ディレクトリ変更時に履歴ファイルに記録
# ===============================================

$env.config.hooks.env_change = (
    $env.config.hooks.env_change?
    | default {}
    | upsert PWD {|config|
        $config.PWD?
        | default []
        | append {|before, after|
            let history_file = ($nu.home-path | path join ".config/nushell/cd_history.txt")
            # 現在のディレクトリを履歴に追加（改行付き）
            $"($after)\n" | save --append --raw $history_file
        }
    }
)

# ===============================================
# Carapace 補完設定
# https://carapace.sh/
# ===============================================

$env.config = ($env.config | upsert completions {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
    external: {
        enable: true
        max_results: 100
        completer: {|spans|
            carapace $spans.0 nushell ...$spans | from json
        }
    }
})

