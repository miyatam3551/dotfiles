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

-- 非アクティブペインの視覚的区別
config.inactive_pane_hsb = {
  saturation = 0.8,  -- 彩度を下げる
  brightness = 0.4,  -- 明るさを下げる
}

-- タブバーを非表示（tmuxを使用）
config.enable_tab_bar = false

-- スクロールバック
config.scrollback_lines = 10000

-- カーソル設定
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- キーバインド
config.keys = {
  {
    key = '+',
    mods = 'CMD',
    action = wezterm.action.IncreaseFontSize
  },
  {
      key = "Enter",
      mods = "SHIFT",
      action = wezterm.action{SendString="\x1b\r"}
  },
}

return config
