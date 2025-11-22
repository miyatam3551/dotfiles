function qiita-show --description 'Qiita記事をブラウザで開く'
    # 引数チェック
    if test (count $argv) -eq 0
        echo "使用法: qiita-show <file_path>"
        echo "例: qiita-show public/newArticle001.md"
        return 1
    end

    set -l article_file $argv[1]

    # .mdファイルでない場合はbasenameとして扱う（後方互換性）
    if not string match -q "*.md" $article_file
        set article_file "public/$article_file.md"
    end

    # ファイルの存在確認
    if not test -f $article_file
        echo "エラー: $article_file が見つかりません"
        return 1
    end

    # front-matterから必要な情報を抽出
    set -l is_private (grep -E '^private:' $article_file | awk '{print $2}')
    set -l article_id (grep -E '^id:' $article_file | awk '{print $2}')

    # Qiita設定ファイルからユーザー名を取得（存在する場合）
    # デフォルトのユーザー名
    set -l username "miyatam3551"

    if test -z "$article_id"
        echo "エラー: 記事IDが見つかりません。記事がまだ投稿されていない可能性があります"
        return 1
    end

    # URLパスを決定
    set -l url
    if test "$is_private" = "true"
        set url "https://qiita.com/$username/private/$article_id"
    else
        set url "https://qiita.com/$username/items/$article_id"
    end

    echo "記事を開きます: $url"
    open $url
end
