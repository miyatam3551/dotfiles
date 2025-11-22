# ===============================================
# 基本設定 / Basic Configuration
# ===============================================

# 言語設定
## 理由: 日本語環境での文字化けを防ぐため、英語に設定
set LANG en_US.UTF-8

# ウェルカムメッセージを無効化
## 理由: ターミナル起動時のメッセージが不要な場合に設定
set -g fish_greeting ""

# vi-mode設定
## 理由: fishにてviモードでのキーバインディングを有効にするため
function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings insert
end

# デフォルトエディタ
# 理由: システム全体で使用するエディタをvimに設定
set -x EDITOR "vim"

# Claude 設定ファイルの保存先
set -x CLAUDE_CONFIG_DIR "$HOME/.config/claude"

# ===============================================
# 環境変数 / Environment Variables  
# ===============================================

# Python仮想環境のプロンプト無効化
# 理由: 仮想環境のプロンプト表示を無効にすることで、プロンプトがシンプルになる
set -x VIRTUAL_ENV_DISABLE_PROMPT "true"

# ===============================================
# パッケージマネージャ初期化 / Package Managers
# ===============================================

# Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# direnv
eval (direnv hook fish)

# ===============================================
# パス設定 / PATH Configuration
# ===============================================

# deck
fish_add_path (go env GOPATH)/bin

# Cargo (Rust)
fish_add_path $HOME/.cargo/bin

# Poetry (Python)
fish_add_path $HOME/.local/bin

# Go
fish_add_path $HOME/go/bin

# Python自動仮想環境切り替え
source ~/.config/fish/functions/autoActivateVenv.fish

# ===============================================
# 略語の初期化 / Abbreviations Initialization
# ===============================================

# 既存の略語をクリア
for abbr_name in (abbr -l)
    abbr -e $abbr_name
end

# ===============================================
# FZF
# ===============================================

# FZFユーティリティ関数を読み込み
source ~/.config/fish/functions/fzf_utilities.fish

# FZF関数のショートカット
alias cf=fzf_change_directory          # fzfでサブディレクトリを検索して移動
alias vf=fzf_file_selector         # fzfでファイルを検索してvimで開く
alias cdh=fzf_change_directory_history # fzfでディレクトリ履歴から移動
alias his=fzf_command_history         # fzfでコマンド履歴を検索・実行
alias sshc=fzf_ssh_connect      # fzfでSSH設定から接続先を選択

# diff
abbr -a diff "delta"  # Deltaで差分表示

# AI/開発ツール
abbr -a q "q chat --model claude-4-sonnet"  # Claude 4 Sonnetモデルでチャット開始
abbr -a cc "claude"                          # Claude CLIを起動

# GitHub CLI
abbr -a ghrm "gh repo delete --yes"         # GitHubリポジトリを強制削除（確認なし）
abbr -a ghls "gh repo list"                 # GitHubリポジトリ一覧を表示

# ファイル操作（安全オプション付き）
abbr -a mv "mv -i"           # ファイル移動時に上書き確認
abbr -a cp "cp -i"           # ファイルコピー時に上書き確認  
abbr -a rr "rm -rf"          # ディレクトリを強制削除（注意：危険なコマンド）

# インフラツール
abbr -a tf "terraform"       # Terraformコマンドの短縮形
abbr -a mp "multipass"       # Multipass（軽量VM）コマンドの短縮形

# ユーティリティ
abbr -a cal "cal -A 1"       # カレンダー表示（翌月も含む）
abbr -a cl "clear"           # ターミナル画面をクリア

# ディレクトリ操作
abbr -a .. "cd .."           # 親ディレクトリに移動
abbr -a ... "cd ../.."       # 2階層上のディレクトリに移動
abbr -a .... "cd ../../.."   # 3階層上のディレクトリに移動
abbr -a fn "cd ~/ghq && mise new"
abbr -a fi "cd ~/ghq && mise enter"
abbr -a fy "cd ~/ghq && mise clone"
abbr -a fd "cd ~/ghq && mise delete"
abbr -a fl "cd ~/ghq && mise info && cd -"
abbr -a fq "tmux detach && clear"

# Git操作
abbr -a gs "git status"      # Gitステータス確認
abbr -a gcb "git checkout -b"  # 新しいブランチを作成してチェックアウト
abbr -a gba "git branch --all"  # 全ブランチ一覧（リモート含む）
alias gc=fzf_git_checkout_branch # fzfでGitブランチを選択してチェックアウト
alias gbd=fzf_git_delete_branch  # fzfでブランチを選択して削除
alias gl=display_git_log  # グラフ形式の美しいコミット履歴
alias gr=change_to_git_root  # Gitリポジトリのルートディレクトリに移動
alias gpsb=git_push_new_branch  # 現在のブランチを新しいリモートブランチとしてプッシュ
source ~/.config/fish/functions/cghq.fish

# ファイル表示
abbr -a la "ls -A"           # 隠しファイルも含めて一覧表示（.と..は除く）
abbr -a ll "ls -alF"         # 詳細情報付きでファイル一覧表示
abbr -a count_files "ls -AF | grep -v / | wc -l"  # ディレクトリ内のファイル数をカウント

# メンテナンス
abbr -a rmabbr 'for a in (abbr --list); abbr --erase $a; end'  # 全ての略語を削除

# ===============================================
# エイリアス設定 / Aliases
# ===============================================

alias gac='git add . && git commit -m'
alias ls=lsd
alias cat='bat --style=plain --paging=always --color=always'
alias less='bat --style=plain --paging=always --color=always'

# ===============================================
# プロンプト / Prompt
# ===============================================

starship init fish | source

# ===============================================
# 外部統合 / External Integrations
# ===============================================

# OrbStack (Docker代替)
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
mise activate fish | source

source ~/.config/fish/functions/autoActivateVenv.fish

# yazi
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
