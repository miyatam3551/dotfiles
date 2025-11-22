# ===============================================
# ghq 連携関数 / ghq Integration Functions
# ===============================================

# ===============================================
# リポジトリ検索・移動
# skim(sk) を使用してリポジトリをfuzzy検索し、選択したリポジトリに移動
# ===============================================
export def --env repos [] {
    # プレビューコマンドを構築（ezaがあれば使用、なければls）
    let preview_cmd = if (which eza | is-not-empty) {
        "ghq list --full-path --exact {} | xargs eza --tree --level=2"
    } else {
        "ghq list --full-path --exact {} | xargs ls -la"
    }

    let repo = (ghq list | sk --preview $preview_cmd)
    if ($repo | is-empty) {
        return
    }
    let repo_path = (ghq list --full-path | lines | where {|x| $x | str contains $repo} | first)
    cd $repo_path
}

# ===============================================
# ghqルートディレクトリに移動
# ===============================================
export def --env repo-root [] {
    let ghq_root = (ghq root | str trim)
    cd $ghq_root
}

# ===============================================
# リポジトリをクローン
# ghq get のラッパー。GitHub shorthand（user/repo）またはURLを指定
# ===============================================
export def --env repo-clone [
    repo: string  # リポジトリURL or GitHub shorthand (e.g., "user/repo")
    --update (-u) # すでに存在する場合は更新
] {
    # shorthand形式（user/repo）かどうかを判定
    let is_shorthand = (
        ($repo | str contains "/") and
        (not ($repo | str starts-with "git@")) and
        (not ($repo | str starts-with "http"))
    )

    let clone_url = if $is_shorthand {
        # ~/.ssh/configからGitHubホストを取得
        let github_hosts = (
            open ~/.ssh/config
            | lines
            | where {|line| $line | str starts-with "Host github"}
            | each {|line| $line | str replace "Host " "" | str trim}
        )

        if ($github_hosts | is-empty) {
            print "エラー: ~/.ssh/config にGitHubホストが見つかりません"
            return
        }

        # 複数ある場合は選択させる
        let selected_host = if ($github_hosts | length) > 1 {
            $github_hosts | str join "\n" | sk --prompt "GitHubアカウントを選択: " | str trim
        } else {
            $github_hosts | first
        }

        if ($selected_host | is-empty) {
            return
        }

        # SSH URL形式に変換
        $"git@($selected_host):($repo).git"
    } else {
        $repo
    }

    # クローン実行
    if $update {
        ghq get -u $clone_url
    } else {
        ghq get $clone_url
    }

    # クローン後、そのディレクトリに移動
    let repo_name = ($repo | split row "/" | last | str replace ".git" "")
    let repo_path = (ghq list --full-path | lines | where {|x| $x | str ends-with $repo_name} | first)

    if not ($repo_path | is-empty) {
        print $"リポジトリをクローンしました: ($repo_path)"
        cd $repo_path
    }
}

# ===============================================
# 現在のリポジトリ情報を表示
# パス、origin URL、現在のブランチ、リモートブランチなどを表示
# ===============================================
export def repo-info [] {
    if not (".git" | path exists) {
        print "現在のディレクトリはGitリポジトリではありません"
        return
    }

    let repo_path = (pwd)
    let ghq_root = (ghq root)

    # ghq管理下かチェック
    let is_ghq_repo = ($repo_path | str starts-with $ghq_root)

    # Git情報を取得
    let branch = (git branch --show-current)
    let origin = (git remote get-url origin | complete | get stdout | str trim)
    let remote_branch = (git rev-parse --abbrev-ref --symbolic-full-name '@{u}' | complete | get stdout | str trim)

    print "=== リポジトリ情報 ==="
    print $"パス: ($repo_path)"
    print $"ghq管理: ($is_ghq_repo)"
    print $"Origin: ($origin)"
    print $"現在のブランチ: ($branch)"
    if not ($remote_branch | is-empty) {
        print $"リモートブランチ: ($remote_branch)"
    }

    # コミット状態
    let status = (git status --short)
    if ($status | is-empty) {
        print "ステータス: クリーン (変更なし)"
    } else {
        print $"ステータス: 変更あり\n($status)"
    }
}
