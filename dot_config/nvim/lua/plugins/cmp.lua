-- blink.cmp のカスタマイズ
-- Markdown ファイルでは補完を無効化
return {
  "saghen/blink.cmp",
  opts = {
    enabled = function()
      -- Markdown ファイルタイプでは補完を無効化
      return vim.bo.filetype ~= "markdown"
    end,
  },
}
