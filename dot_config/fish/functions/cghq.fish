function cghq
  set -l key (ghq list | fzf --preview 'ghq list -p {}' --preview-window=up:3:wrap --height=80% --reverse)
  test -n "$key"; or return

  set -l path (ghq list -p $key)   # 相対 → 絶対に変換
  test -d "$path"; and cd -- "$path"; or echo "not found: $path"
end
