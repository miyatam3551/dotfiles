# env.nu

# ===============================================
# 基本環境変数 / Basic Environment Variables
# ===============================================

$env.LANG = "en_US.UTF-8"
$env.EDITOR = "vim"
$env.CLAUDE_CONFIG_DIR = ($env.HOME + '/.config/claude')
$env.STARSHIP_CONFIG = ($env.HOME + '/.config/starship.toml')
$env.KUBECONFIG = ($env.HOME + '/.config/kube/config')
$env.AWS_PROFILE = 'private-dev'

# ===============================================
# vi-mode のプロンプトの定義
# ===============================================

$env.PROMPT_INDICATOR_VI_NORMAL = " ❯ "
$env.PROMPT_INDICATOR_VI_INSERT = " ❯ "

# ===============================================
# パス設定 / PATH Configuration
# ===============================================

# 既存のPATHを取得して、必要なパスを追加
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend [
        ($env.HOME + '/.cargo/bin')          # Cargo (Rust)
        ($env.HOME + '/.local/bin')          # uv, pipx など
        ($env.HOME + '/go/bin')              # Go (標準)
        ('/usr/local/bin')                   # awscli
    ]
    | uniq                                    # 重複を除去
)

# ===============================================
# パッケージマネージャ・ツール統合
# ===============================================

# Homebrew
# Homebrewのパスが含まれていない場合は追加
if not ("/opt/homebrew/bin" in $env.PATH) {
    $env.PATH = ($env.PATH | prepend "/opt/homebrew/bin")
}

# Homebrewの環境変数を設定
$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"
$env.MANPATH = ("/opt/homebrew/share/man:" + ($env.MANPATH? | default ''))
$env.INFOPATH = ("/opt/homebrew/share/info:" + ($env.INFOPATH? | default ''))

# ===============================================
# mise (ランタイムバージョン管理)
# ===============================================

$env.MISE_SHELL = "nu"

def --env add-hook [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

export def --env --wrapped mise [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^"/opt/homebrew/bin/mise"
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/opt/homebrew/bin/mise" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"/opt/homebrew/bin/mise" $command ...$rest
  }
}

def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      if ($var.name | str upcase) == 'PATH' {
        $env.PATH = ($var.value | split row (char esep))
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" {
      hide-env $var.name
    }
  }
}

def --env mise_hook [] {
  ^"/opt/homebrew/bin/mise" hook-env -s nu
    | parse vars
    | update-env
}

let mise_hook = {
  condition: { "MISE_SHELL" in $env }
  code: { mise_hook }
}
add-hook hooks.pre_prompt $mise_hook
add-hook hooks.env_change.PWD $mise_hook
