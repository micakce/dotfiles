return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 900,
  },
  {
    "maxmx03/solarized.nvim",
    lazy = true,
    priority = 1000,
    ---@type solarized.config
    opts = {},
    config = function(_, opts)
      require("solarized").setup(opts)
      --   vim.o.termguicolors = true
      --   vim.o.background = "light"
      --   require("solarized").setup(opts)
      --   vim.cmd.colorscheme("solarized")
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        vim.cmd("!sed -ibak 's/Solarized-Light.toml/Tokyonight_night.toml/g' ~/.config/alacritty/alacritty.toml")
        vim.cmd("colorscheme tokyonight-moon")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        vim.cmd("!sed -ibak 's/Tokyonight_night.toml/Solarized-Light.toml/g' ~/.config/alacritty/alacritty.toml")
        vim.cmd("colorscheme solarized")
      end,
    },
  },
}
