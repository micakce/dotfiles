-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<ESC>", {})
vim.keymap.set("t", "<c-q>", "<c-\\><c-n>", {})
vim.keymap.set("t", "<c-h>", "<c-\\><c-n><c-w>h", {})
vim.keymap.set("t", "<c-j>", "<c-\\><c-n><c-w>j", {})
vim.keymap.set("t", "<c-k>", "<c-\\><c-n><c-w>k", {})
vim.keymap.set("t", "<c-l>", "<c-\\><c-n><c-w>l", {})
