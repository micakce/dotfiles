return {
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      snippets = { preset = "luasnip" },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    opts = function()
      require("luasnip.loaders.from_lua").lazy_load({
        paths = vim.fn.stdpath("config") .. "/lua/snippets",
      })
    end,
  },
}
