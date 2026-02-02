-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 相対行番号を無効化（通常の行番号のみ表示）
vim.opt.relativenumber = false

-- カーソル行・カーソル列のハイライト
vim.opt.cursorline = true -- LazyVimでデフォルト有効だが明示的に設定
vim.opt.cursorcolumn = true
