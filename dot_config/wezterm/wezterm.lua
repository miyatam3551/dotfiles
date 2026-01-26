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
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background

  -- タブタイトルの優先順位: 手動設定 > 自動生成
  local tab_title = tab.tab_title
  if not tab_title or #tab_title == 0 then
    tab_title = tab.active_pane.title
  end

  local title = "   " .. wezterm.truncate_right(tab_title, max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

-- スクロールバック
config.scrollback_lines = 10000

-- カーソル設定
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

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
  }
}

return config
