return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   enabled = false,
  --   keys = {
  --     {
  --       "<leader>%",
  --       "<CMD>Neotree focus<CR>",
  --       desc = "Focus Files",
  --     },
  --   },
  -- },
}
