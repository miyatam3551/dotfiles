-- bullets.vim
-- Markdown で Enter 時に箇条書きを自動継続
return {
  "bullets-vim/bullets.vim",
  ft = { "markdown", "text", "gitcommit" },
  init = function()
    vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit", "scratch" }
  end,
}
