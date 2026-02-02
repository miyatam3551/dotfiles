return {
  "folke/flash.nvim",
  opts = {
    modes = {
      -- f の行内検索モードを無効化
      char = {
        keys = { "F", "t", "T", ";", "," }, -- "f" を除外
      },
    },
  },
  keys = {
    -- s のマッピングを無効化（元の Vim の s を復活）
    { "s", mode = { "n", "x", "o" }, false },
    -- f で flash（画面全体ジャンプ）を起動
    {
      "f",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
  },
}
