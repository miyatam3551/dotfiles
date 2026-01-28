--
-- (注意) 既に~/.wezterm.lua が存在する場合、
-- ~/.config/wezterm/wezterm.lua は優先順位がそれよりも低いので読み込まれない
--
-- WezTerm Configuration
local wezterm = require 'wezterm'
local config = {}

-- 新しい設定APIを使用（WezTerm 20220624以降）
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- tabline.wez プラグインを読み込み
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- 基本セットアップ
tabline.setup({
  options = {
    theme = 'Catppuccin Mocha',  -- テーマ指定
  },
  sections = {
    tabline_a = { },
    tabline_b = { },
    tabline_c = { },
    tab_active = {
      'index',
      { 'cwd', padding = { left = 0, right = 1 } },
    },
    tab_inactive = {
      'index',
      { 'cwd', padding = { left = 0, right = 1 } },
    },
    tabline_x = { 'ram', 'cpu' },  -- システムリソース
    tabline_y = { 'battery', { 'datetime', style = '%d %a %H:%M' } },  -- バッテリー、日時
    tabline_z = { 'hostname' },       -- 右端: ホスト名
  },
})
tabline.apply_to_config(config)

-- 環境変数設定
config.set_environment_variables = {
  XDG_CONFIG_HOME = wezterm.home_dir .. '/.config',
}

-- デフォルトシェルをzshに設定
config.default_prog = { '/bin/zsh' }

-- カラースキーム
config.color_scheme = 'Solarized Dark (Gogh)'

-- フォント設定
config.font = wezterm.font('UDEV Gothic 35NF', { weight = 'Regular' })
config.font_size = 20.0

-- ウィンドウ設定
config.window_background_opacity = 1.0
-- config.macos_window_background_blur = 20
config.window_decorations = "RESIZE|TITLE"

-- 背景画像設定
config.window_background_image = wezterm.home_dir .. '/.config/wezterm/background.jpg'
config.window_background_image_hsb = {
  brightness = 0.2,  -- 明るさ（0.0-1.0）
  hue = 1.0,         -- 色相（0.0-1.0）
  saturation = 1.0,  -- 彩度（0.0-1.0）
}

-- タブバー設定
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false  -- タブが1つでもステータスラインを表示
config.use_fancy_tab_bar = false  -- tabline.wez と互換性を保つため false に
config.tab_bar_at_bottom = false   -- タブバーを下部に配置
-- スクロールバック
config.scrollback_lines = 10000

-- カーソル設定
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- Leader キー設定（Vim風）
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }

-- キーバインド
config.keys = {
  -- タブ操作
  {
    key = 't',
    mods = 'CMD',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  -- タブ間移動
  {
    key = 'j',
    mods = 'CMD',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = '+',
    mods = 'CMD',
    action = wezterm.action.IncreaseFontSize
  },
  -- タブの名前変更
  {
      key = 'e',
      mods = 'CMD',
      action = wezterm.action.PromptInputLine {
            description = 'Enter new name for tab:',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
  },
  {
      key = "Enter",
      mods = "SHIFT",
      action = wezterm.action{SendString="\x1b\r"}
  },
  -- ペイン分割（Leader + キー）
  {
    key = '\\',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- ペイン間移動
  {
    key = 'h',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
}

return config
