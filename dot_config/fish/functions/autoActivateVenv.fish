# activate venv automatically like direnv
# https://qiita.com/koshigoe/items/15351b1b4d137d47ca00

function auto_venv --on-variable PWD
    # 現在のディレクトリから親ディレクトリを順に探索
    set search_dir $PWD

    while true
        # .venv ディレクトリが存在する場合
        if test -d "$search_dir/.venv"
            # すでにアクティブな venv かどうか判定
            if test "$VIRTUAL_ENV" = "$search_dir/.venv"
                echo "[auto_venv] venv already active: $VIRTUAL_ENV"
            else
                echo "[auto_venv] activating venv: $search_dir/.venv"
                source "$search_dir/.venv/bin/activate.fish"
            end
            return
        end

        # ルートまで到達した場合
        if test "$search_dir" = "/"
            if set -q VIRTUAL_ENV
                echo "[auto_venv] deactivating venv: $VIRTUAL_ENV"
                deactivate
            else
                echo "[auto_venv] no venv found."
            end
            return
        end

        # 親ディレクトリへ移動
        set search_dir (dirname $search_dir)
    end
end

