-- substitute.nvim
-- s でヤンクした内容にモーション範囲を置換（ReplaceWithRegister の代替）
return {
  "gbprod/substitute.nvim",
  keys = {
    {
      "s",
      function()
        require("substitute").operator()
      end,
      desc = "Substitute with register",
    },
    {
      "ss",
      function()
        require("substitute").line()
      end,
      desc = "Substitute line",
    },
    {
      "s",
      function()
        require("substitute").visual()
      end,
      mode = "x",
      desc = "Substitute visual",
    },
  },
  config = function()
    require("substitute").setup()
  end,
}
