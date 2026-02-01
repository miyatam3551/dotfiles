-- vim-tmux-navigator
-- Ctrl+hjkl で Neovim と tmux のペイン間をシームレスに移動
return {
  "christoomey/vim-tmux-navigator",
  event = "VeryLazy",
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Tmux Left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Tmux Down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Tmux Up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Tmux Right" },
  },
}
