return {
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(hl, _)
        -- カーソル行・カーソル列のハイライト色
        hl.CursorLine = { bg = "#363c58" } -- tokyonight風
        hl.CursorColumn = { bg = "#363c58" }
      end,
    },
  },
}
