# ===============================================
# カスタム関数定義 / Custom Functions
# ===============================================

# ===============================================
# ll 定義
# https://www.nushell.sh/book/aliases.html#replacing-existing-commands-using-aliases
# ===============================================

# List the filenames, sizes, and modification times of items in a directory.
export def ll [
    --short-names (-s), # Only print the file names, and not the path
    --full-paths (-f),  # display paths as absolute paths
    --du (-d),          # Display the apparent directory size ("disk usage") in place of the directory metadata size
    --directory (-D),   # List the specified directory itself instead of its contents
    --mime-type (-m),   # Show mime-type in type column instead of 'file' (based on filenames only; files' contents are not examined)
    --threads (-t),     # Use multiple threads to list contents. Output will be non-deterministic.
    ...pattern: glob,   # The glob pattern to use.
]: [ nothing -> table ] {
    let pattern = if ($pattern | is-empty) { [ '.' ] } else { $pattern }
    (ls
        --all
        --long
        --short-names=$short_names
        --full-paths=$full_paths
        --du=$du
        --directory=$directory
        --mime-type=$mime_type
        --threads=$threads
        ...$pattern
    ) | select name type mode user group size modified | sort-by type name -i
}

# ===============================================
# yazi の設定
# yazi を閉じた時に cd を反映させる
# https://yazi-rs.github.io/docs/quick-start/
# ===============================================
export def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# ===============================================
# mkcd の設定
# ===============================================
export def mkcd [dir: string] {
  mkdir $dir
  cd $dir
}
