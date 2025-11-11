-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.g.lazyvim_picker = "fzf"
--
--
-- Set the background first
vim.opt.background = "light"

-- Set the colorscheme using vim.g (Global Vim Variable)
-- LazyVim ensures this variable is read and the colorscheme is applied at the right time.
vim.g.colorscheme = "catppuccin-latte"

-- Optional: If you want to use the theme's built-in setup
-- You would typically create a dedicated config file for this (see below)
