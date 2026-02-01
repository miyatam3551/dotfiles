-- lang.markdown の機能を無効化
-- Obsidian ノートにはリンターもレンダリングも不要
return {
  -- marksman LSP を無効化（Wikiリンクの検証でエラーが大量発生するため）
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          enabled = false,
        },
      },
    },
  },

  -- markdownlint を無効化
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {}, -- markdownlint を除外
      },
    },
  },

  -- render-markdown.nvim を無効化
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
}
