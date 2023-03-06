--[[
lvim is the global options object
Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
vim.opt.relativenumber = true

-- -- Gitsigns
-- require('lvim.core.gitsigns').toggle_current_line_blame();
-- vim.api.nvim_echo({ { vim.bo.buftype, "None" } }, true, {})


-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
--
--

-- Define a function to check if the terminal window exists
function Terminal_exists()
  return vim.fn.bufexists(vim.g.term_bufnr) == 1
end

-- Define a function to toggle the terminal window
function Toggle_term()
  if Terminal_exists() then
    -- Terminal window exists, so hide it
    local winnr = vim.fn.winnr('#' .. vim.g.term_bufnr)
    vim.api.nvim_win_hide(winnr)
  else
    -- Terminal window does not exist, so create it
    local size = math.floor(vim.o.columns * 0.4)
    vim.cmd('botright vsplit term://bash')
    vim.api.nvim_win_set_width(0, size)
    vim.g.term_bufnr = vim.api.nvim_get_current_buf()
    vim.cmd('wincmd l')
  end
end

-- Set the ToggleTerm keymapping to toggle the terminal window
vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>lua Toggle_term()<CR>', { noremap = true, silent = true })
lvim.keys.normal_mode["<M-s>"] = "msvip<esc><cmd>ToggleTermSendVisualLines 1024<CR>`s"
lvim.keys.normal_mode["<M-S>"] = "<cmd>1024ToggleTerm dir=%:p:h direction=vertical size=60<cr>"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', {})
local nnn = "<Cmd>lua require('lvim.core.terminal')._exec_toggle({ cmd = 'nnn', count = 102, direction = 'float' })<CR>"
-- lvim.keys.normal_mode["<M-t>"] = ":w<cr>"
vim.api.nvim_set_keymap('n', '<M-t>', ':ToggleTerm<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<M-t>', '<c-\\><c-n>:ToggleTerm<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-w>q', '<C-\\><C-n>', { noremap = true, silent = true })

vim.cmd([[command! UPPERSQL normal! mh:%s/^\<with\>\|\<as\>\|\<select\>\|\<left\>\|\<join\>\|\<case\>\|\<else\>\|\<group\>\|\<by\>\|\<from\>\|\<end\>\|\<when\>\|\<is\>\|\<where\>\|\<not\>\|\<null\>\|\<then\>|\|\<on\>\|\<like\>\|\<then\>\|\<and\>\|\<or\>/\U&/g<CR>`h]])

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["/"] = { "<cmd>NvimTreeFindFile<cr>", "Focus explorer" }
lvim.builtin.which_key.mappings["M"] = { '"zyip:call Send_to_tmux(\'.v:count.\')<CR>', "Send2Tmux" }
lvim.builtin.which_key.mappings["l"]["R"] = { "<cmd>Telescope lsp_references<cr>", "References" }
lvim.builtin.which_key.mappings["l"]["M"] = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" }
lvim.builtin.which_key.mappings["l"]["C"] = { "<cmd>Telescope lsp_incoming_calls<cr>", "Incoming calls" }
lvim.builtin.which_key.mappings["l"]["D"] = { "<cmd>Telescope lsp_definitions<cr>", "Definitions" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["n"] = { nnn, "nnn" }
lvim.builtin.which_key.mappings["x"] = { "<Cmd>BufferKill<CR>", "Close Buffer" }
lvim.builtin.which_key.mappings["c"] = { "<Cmd>tabnew<CR>", "New Tab" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "go",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skiipped for the current filetype
-- vim.tbl_map(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   -- { command = "black", filetypes = { "python" } },
--   -- { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "eslint",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "typescript" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }
-- these are all the default values
-- Additional Plugins
lvim.plugins = {
  { 'ibhagwan/fzf-lua',
    -- optional for icon support
    requires = { 'nvim-tree/nvim-web-devicons' }
  },
  { "christoomey/vim-tmux-navigator" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  --ZettleKasten note takin
  { "renerocksai/telekasten.nvim" },
  { "renerocksai/calendar-vim" },
  -- Markadown
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
      vim.g.mkdp_auto_close = 0
    end,
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end
  },
  -- TPOPE
  { "tpope/vim-abolish" },
  { "tpope/vim-eunuch" },
  { "tpope/vim-repeat", },
  {
    "tpope/vim-fugitive",
  },
  -- JUNEGUNN
  {
    'junegunn/fzf',
    run = ':call fzf#install()',
  },
  {
    "junegunn/vim-easy-align",
    config = function()
      vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})
      vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})
    end,

  },
  { "ggandor/lightspeed.nvim" },
  { "nvim-pack/nvim-spectre" },
  { "nvim-treesitter/playground" },
  { "nvim-treesitter/nvim-treesitter-context" },
  {
    "wellle/targets.vim",
    config = function()
      vim.cmd("autocmd User targets#mappings#user call targets#mappings#extend({ 'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]} })")
    end
  },
  {
    "ThePrimeagen/harpoon", config = function()
      require("harpoon").setup()
      vim.api.nvim_set_keymap("n", "<M-a>", ':lua require("harpoon.mark").add_file()<cr>', { silent = true })
      vim.api.nvim_set_keymap("n", "<M-h>", ':lua require("harpoon.ui").toggle_quick_menu()<cr>', { silent = true })
      vim.api.nvim_set_keymap("n", "<M-p>", ':lua require("harpoon.ui").nav_prev()<cr>', { silent = true })
      vim.api.nvim_set_keymap("n", "<M-n>", ':lua require("harpoon.ui").nav_next()<cr>', { silent = true })
      vim.api.nvim_set_keymap("n", "<M-q>", ':lua require("harpoon.ui").nav_file(1)<cr>', { silent = true })
      vim.api.nvim_set_keymap("n", "<M-w>", ':lua require("harpoon.ui").nav_file(2)<cr>', { silent = true })
      vim.api.nvim_set_keymap("n", "<M-e>", ':lua require("harpoon.ui").nav_file(3)<cr>', { silent = true })
      vim.api.nvim_set_keymap("n", "<M-r>", ':lua require("harpoon.ui").nav_file(4)<cr>', { silent = true })
      -- vim.api.nvim_set_keymap("n", "<M-t>", ':lua require("harpoon.ui").nav_file(5)<cr>', { silent = true })
      vim.api.nvim_set_keymap("n", "<M-y>", ':lua require("harpoon.ui").nav_file(6)<cr>', { silent = true })
    end,
  },
  { "mg979/vim-visual-multi" },
  {
    "tpope/vim-dadbod",
    opt = true,
    requires = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
      "vim-scripts/dbext.vim",
    },
    config = function()
      require("config.dadbod").setup()
    end,
    cmd = { "DBUIToggle", "DBUI", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
  },

}



vim.cmd([[
function! Send_to_tmux(count)
  let _count = (a:count == 0) ? 'bottom-right' : a:count
  let text = @z
  let text = substitute(text, '\n', '\r', 'g')
  let text = substitute(text, "'", '"', 'g')
  silent execute "!tmux send-keys -Rt" . _count . " '" .  text  . "' Enter"
  unlet _count
  unlet text
endfunction
nnoremap <expr> <Leader>M '"zyip:call Send_to_tmux('.v:count.')<CR>'
xnoremap <expr> <Leader>M '"zy:call Send_to_tmux('.v:count.')<CR>'
]])

-- vim.api.nvim_set_keymap('n', '<space>M', , {})
-- vim.api.nvim_set_keymap('x', '<space>M', '"zyip:call Send_to_tmux(\'.v:count.\')<CR>', {})

-- -- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.*" },
--   -- enable git blame line
--   callback = function()
--     require('gitsigns').toggle_current_line_blame()
--   end
-- })

-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })

vim.opt.list = true
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
  -- for example, context is off by default, use this to turn it on
  show_current_context = true,
  show_current_context_start = true,
  show_end_of_line = true,
  space_char_blankline = " ",
}

local fzf_defaults = require 'fzf-lua'.defaults

fzf_defaults.git.bcommits.actions = {
  ["default"] = require 'fzf-lua'.actions.git_buf_edit,
  ["ctrl-s"]  = require 'fzf-lua'.actions.git_buf_split,
  ["ctrl-v"]  = function(selected, opts)
    local commit_hash = selected[1]:match("[^ ]+")
    local cmd = string.format("Gvdiffsplit %s", commit_hash)
    vim.cmd(cmd)
  end,
  ["ctrl-t"]  = require 'fzf-lua'.actions.git_buf_tabedit,
}

vim.api.nvim_create_user_command(
  'Lcommits',
  function(opts)
    vim.cmd("messages clear")
    for key, value in pairs(opts) do
      print('\t', key, value)
    end
    local start_line = opts.line1
    local end_line = opts.line2
    require 'fzf-lua'.git_bcommits({
      prompt = "LCommits> ",
      cmd    = "git log " ..
          opts.args .. " --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))" ..
          "%Creset %s %C(blue)<%an>%Creset' -L " .. start_line .. "," .. end_line .. ":<file> --no-patch",
    })
  end,
  {
    nargs = '*',
    range = true,
    force = true,
  })

require 'fzf-lua'.setup(fzf_defaults)


-- Check if the current file belongs to a Git repository and toggle the current line blame in Gitsigns
function ShouldToggleGitBlame()
  local output = vim.fn.systemlist("git rev-parse --is-inside-work-tree 2>/dev/null")
  if not vim.tbl_isempty(output) then
    local gitsigns = require('gitsigns')
    gitsigns.toggle_current_line_blame()
  end
end

-- Call the `print_git_status()` function whenever a buffer is entered
vim.cmd([[
  augroup git_check
    autocmd!
    autocmd BufEnter * lua ShouldToggleGitBlame()
  augroup END
]])
