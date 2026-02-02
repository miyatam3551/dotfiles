return {
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(hl, _)
        -- カーソル行・カーソル列のハイライト色
        hl.CursorLine = { bg = "#12131a" } -- めっちゃ暗め
        hl.CursorColumn = { bg = "#12131a" }
      end,
    },
  },
}
