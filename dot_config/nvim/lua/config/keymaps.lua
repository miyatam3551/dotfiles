-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set

-- ============================================================
-- vimrc から移行したキーマップ
-- ============================================================

-- x: ヤンクせずに削除（ブラックホールレジスタ）
keymap({ "n", "v" }, "x", '"_x', { desc = "削除（ヤンクなし）" })

-- Shift+hjkl: 高速移動
keymap({ "n", "v" }, "<S-j>", "10j", { desc = "10行下へ" })
keymap({ "n", "v" }, "<S-k>", "10k", { desc = "10行上へ" })
keymap({ "n", "v" }, "<S-h>", "^", { desc = "行頭へ" })
keymap({ "n", "v" }, "<S-l>", "$", { desc = "行末へ" })

-- </> : インデント後も選択を維持
keymap("v", "<", "<gv", { desc = "インデント減（選択維持）" })
keymap("v", ">", ">gv", { desc = "インデント増（選択維持）" })

-- Shift+Tab: インサートモードでインデント減
keymap("i", "<S-Tab>", "<C-d>", { desc = "インデント減" })
