# dotfiles

chezmoi で管理している個人用 dotfiles

## シェル & エディタ

### `~/.config/nushell/`

- Nushell の設定ファイル
- `config.nu`: メイン設定（エディタ、プロンプトなど）
- `env.nu`: 環境変数設定
- `modules/`: エイリアスや関数のモジュール（chezmoi: `cm`、kubectl: `k` など）

### `~/.config/fish/`

- バックアップ目的(もう使っていない)
- Fish シェルの設定ファイル
- プラグイン設定とカスタム関数を含む

### `~/.config/vim/vimrc`

- Vim エディタの設定ファイル

## Git & SSH

### `~/.gitconfig`

- Git のグローバル設定
- Delta（差分表示ツール）との連携
- 1Password による SSH 署名設定

### `~/.ssh/config.template`

- SSH 接続設定

## ターミナル & プロンプト

### `~/.config/wezterm/wezterm.lua`

- WezTerm ターミナルエミュレータの設定
- 背景画像やフォント、カラースキームの設定

### `~/.config/starship.toml`

- Starship プロンプトの設定
- Kubernetes、AWS、Azure のコンテキスト表示対応

### `~/.config/tmux/tmux.conf`

- tmux ターミナルマルチプレクサの設定

## macOS ツール

### `~/.config/karabiner/karabiner.json`

- Karabiner-Elements（キーボードカスタマイズツール）の設定

### `~/.hammerspoon/`

- Hammerspoon（macOS 自動化ツール）の設定

## Claude Code

### `~/.config/claude/`

- Claude Code の設定ファイル
- `CLAUDE.md`: グローバル指示ファイル
- `settings.json`: エディタ設定

## セットアップ

### 新しい Mac での初回セットアップ

```bash
# chezmoi をインストール
brew install chezmoi

# dotfiles を適用
chezmoi init --apply git@github.com:miyatam3551/dotfiles.git

# Homebrew パッケージをインストール
brew bundle --global

# LaunchAgent を有効化（Homebrew 自動更新）
launchctl load ~/Library/LaunchAgents/com.homebrew.autoupdate.plist
```

### 設定ファイルの更新

#### 日常的な編集方法（推奨）

```bash
# chezmoi edit でファイルを編集
chezmoi edit ~/.zshrc

# 変更をコミット & プッシュ
chezmoi git add .
chezmoi git commit -- -m "zshrc を更新"
chezmoi git push
```

#### 既存のファイルを直接編集した場合

```bash
# 通常通り編集
vim ~/.vimrc

# chezmoi に反映
chezmoi add ~/.vimrc

# コミット & プッシュ
chezmoi git add .
chezmoi git commit -- -m "vimrc を更新"
chezmoi git push
```

#### 他のマシンの変更を取り込む場合

```bash
# 最新版に同期
chezmoi update
```

## よく使うコマンド

```bash
# 管理されているファイル一覧
chezmoi managed

# ローカルファイルと chezmoi の差分を確認
chezmoi diff

# ファイルを編集（推奨）
chezmoi edit ~/.zshrc

# 変更を適用
chezmoi apply

# 新しいファイルを管理対象に追加
chezmoi add ~/.gitconfig

# Git 操作
chezmoi git status
chezmoi git add .
chezmoi git commit -- -m "コミットメッセージ"
chezmoi git push
```

## Tips

- `chezmoi edit --apply` で編集後すぐに適用
- `chezmoi edit --watch` で保存時に自動適用
- `chezmoi cd` でソースディレクトリに移動（直接 git 操作したい場合）

## 参考

- [chezmoi 公式ドキュメント](https://www.chezmoi.io/)IT
