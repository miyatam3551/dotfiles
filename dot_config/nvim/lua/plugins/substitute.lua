-- substitute.nvim
-- gr でヤンクした内容にモーション範囲を置換（ReplaceWithRegister の代替）
return {
  "gbprod/substitute.nvim",
  keys = {
    {
      "gr",
      function()
        require("substitute").operator()
      end,
      desc = "Substitute with register",
    },
    {
      "grr",
      function()
        require("substitute").line()
      end,
      desc = "Substitute line",
    },
    {
      "gr",
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
