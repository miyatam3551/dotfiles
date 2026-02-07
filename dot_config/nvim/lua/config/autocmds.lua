-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ============================================================
-- .env ファイルのリンター警告を抑制
-- util.dot が .env を sh として認識し shellcheck が SC2034 を出すのを防ぐ
-- ============================================================
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = ".env*",
  callback = function()
    vim.bo.filetype = "conf"
  end,
})

-- ============================================================
-- 特殊ウィンドウ自動クローズ
-- :q 時に neo-tree 等の特殊ウィンドウだけが残っている場合、自動で閉じる
-- https://zenn.dev/vim_jp/articles/ff6cd224fab0c7
-- ============================================================
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local current_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= current_win then
        local buf = vim.api.nvim_win_get_buf(win)
        local buftype = vim.bo[buf].buftype
        -- buftype が空（通常バッファ）があればリターン
        if buftype == "" then
          return
        end
      end
    end
    -- ここまで来たら特殊ウィンドウのみなので閉じる
    vim.cmd("only!")
  end,
})
