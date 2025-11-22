# ===============================================
# FZF ユーティリティ関数集
# ===============================================

# 指定ディレクトリ以下のファイルをfzfで選択してエディタで開く
function fzf_file_selector
    set -l search_dir "."
    if test (count $argv) -gt 0
        set search_dir $argv[1]
    end
    
    set -l file (
        find "$search_dir" \
            \( -path '*/.git' -type d \) -prune -o \
            \( -type f -o -type l \) -print 2> /dev/null \
        | fzf --preview "bat --color=always --style=header,grid {}" --preview-window=right:60%
    )
    if test -n "$file"
        if set -q EDITOR
            $EDITOR $file
        else
            vim $file
        end
    end
end

# 履歴からディレクトリ移動
function fzf_change_directory_history
    set selected_dir (dirh | sed 's/^[^\/]*//' | fzf)
    if test -n "$selected_dir"
        cd $selected_dir
    end
end

# サブディレクトリをfzfで選択して移動
function fzf_change_directory
    set -l dir (find . -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m)
    if test -n "$dir"
        cd $dir
    end
end

# サブファイルをfzfで選択してエディタで開く
function fzf_file_editor
    set -l file (
        find . \
            \( -path '*/.*' -type d \) -prune -o \
            -type f -print 2> /dev/null \
        | fzf +m
    )
    if test -n "$file"
        if set -q EDITOR
            $EDITOR $file
        else
            vim $file
        end
    end
end

# Gitブランチをfzfで選択してcheckout
function fzf_git_checkout_branch
    set -l sel (git branch --all | grep -v HEAD | fzf +m)
    if test -n "$sel"
        set -l branch (echo $sel | sed 's/.* //; s#remotes/[^/]*/##')
        git checkout $branch
    end
end

# コマンド履歴をfzfで検索
function fzf_command_history
    set -l h (history | fzf +m)
    if test -n "$h"
        commandline -r -- $h
    end
end

# SSH接続先をfzfで選択
function fzf_ssh_connect
    set -l host (
        awk '
          tolower($1)=="host" {
            for (i=2; i<=NF; i++) {
              if ($i !~ "[*?]") print $i
            }
          }
        ' ~/.ssh/config | sort | fzf +m
    )
    if test -n "$host"
        ssh $host
    end
end

# Gitブランチをfzfで選択して削除
function fzf_git_delete_branch
    set -l branch (git branch | grep -v '^\*' | grep -v 'main' | grep -v 'master' | sed 's/^ *//' | fzf +m)
    if test -n "$branch"
        echo "ブランチ '$branch' を削除しますか? (y/N): "
        read -n 1 confirm
        if test "$confirm" = "y" -o "$confirm" = "Y"
            git branch -d $branch
        else
            echo "削除をキャンセルしました"
        end
    end
end

# tree コマンドの代替（ezaを使用）
function display_tree
    set -l depth 2
    if test (count $argv) -gt 0
        if test "$argv[1]" = "-L"
            if test (count $argv) -gt 1
                set depth $argv[2]
            end
        end
    end
    eza -T -a -I 'node_modules|.git|.cache' --icons=always -L $depth --color=always | less
end

# Git美しいログ表示
function display_git_log
    git log --graph --oneline --decorate=full --date=short --format='%C(yellow)%h%C(reset) %C(magenta)[%ad]%C(reset)%C(auto)%d%C(reset) %s %C(cyan)@%an%C(reset)'
end

# Gitリポジトリのルートディレクトリに移動
function change_to_git_root
    cd (git rev-parse --show-superproject-working-tree --show-toplevel | head -1)
end

# 現在のブランチを新しいリモートブランチとしてプッシュ
function git_push_new_branch
    git push --set-upstream origin (git branch --contains=HEAD | cut -c3-)
end
