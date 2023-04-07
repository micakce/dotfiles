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
-- Set the ToggleTerm keymapping to toggle the terminal window
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', {})
lvim.builtin.project.patterns = { ".devcontainer", ".dockerignore", ".git", "package.json" }

vim.cmd([[command! UPPERSQL normal! mh:%s/^\<with\>\|\<as\>\|\<select\>\|\<left\>\|\<join\>\|\<case\>\|\<else\>\|\<group\>\|\<by\>\|\<from\>\|\<end\>\|\<when\>\|\<is\>\|\<where\>\|\<not\>\|\<null\>\|\<then\>|\|\<on\>\|\<like\>\|\<then\>\|\<and\>\|\<or\>/\U&/g<CR>`h]])

vim.cmd([[
nnoremap <expr>  <Space>r ReplaceWithPlusRegister()
xnoremap <expr>  <Space>r ReplaceWithPlusRegister()

function! ReplaceWithPlusRegister(type='') abort
  if a:type == ''
    set opfunc=ReplaceWithPlusRegister
    return 'g@'
  endif

  let sel_save = &selection
  let reg_save = getreginfo('"')
  let cb_save = &clipboard
  let visual_marks_save = [getpos("'<"), getpos("'>")]
  echom visual_marks_save

  try
    set clipboard= selection=inclusive
    let commands = #{line: "'[V']\"_dO", char: "`[v`]\"_d", block: "`[\<c-v>`]\"_d"}
    silent exe 'noautocmd keepjumps normal! ' .. get(commands, a:type, '')
    exec 'normal ""P'
  finally
    call setreg('"', reg_save)
    call setpos("'<", visual_marks_save[0])
    call setpos("'>", visual_marks_save[1])
    let &clipboard = cb_save
    let &selection = sel_save
  endtry
endfunction
]])


--
-- Define the keybinding
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
lvim.builtin.which_key.mappings["M"] = { [["zyip:call Send_to_tmux(v:count)<CR>]], "Send2Tmux" }
lvim.builtin.which_key.mappings["l"]["R"] = { "<cmd>Telescope lsp_references<cr>", "References" }
lvim.builtin.which_key.mappings["l"]["M"] = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" }
lvim.builtin.which_key.mappings["l"]["C"] = { "<cmd>Telescope lsp_incoming_calls<cr>", "Incoming calls" }
lvim.builtin.which_key.mappings["l"]["D"] = { "<cmd>Telescope lsp_definitions<cr>", "Definitions" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
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
  {
    "ggandor/leap.nvim",
    config = function()
      require('leap').add_default_mappings()
    end,
  },
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

require('spectre').setup({
  highlight = {
    ui = "String",
    search = "BufferInactiveTarget",
    replace = "DiffText"
  }
})



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



-- Check if the current file belongs to a Git repository and toggle the current line blame in Gitsigns
function ShouldToggleGitBlame()
  local non_file_buf_types = { 'acwrite', 'help', 'quickfix', 'terminal', 'nofile', 'nowrite', 'prompt', 'lspinfo' }
  if vim.tbl_contains(non_file_buf_types, vim.bo.buftype) then
    -- This is not a file buffer, do not run the Git command
    return
  end

  local output = vim.fn.systemlist("git rev-parse --is-inside-work-tree 2>/dev/null")

  if not vim.tbl_isempty(output) then
    local gitsigns = require('gitsigns')
    gitsigns.toggle_current_line_blame()
  end
end

-- -- Call the `print_git_status()` function whenever a buffer is entered
-- vim.cmd([[
--   augroup git_check
--     autocmd!
--     autocmd VimEnter * if bufname("%") != "" | lua ShouldToggleGitBlame()
--   augroup END
-- ]])

function Buffer_is_visible(bufnr)
  for tabnr = 1, vim.fn.tabpagenr("$") do
    for _, bufid in pairs(vim.fn.tabpagebuflist(tabnr)) do
      if bufid == bufnr then
        return true
      end
    end
  end
  return false
end

-- Define a function to save the buffer number of the current terminal
function Save_last_terminal_bufnr()
  local term_bufnr = vim.fn.bufnr('%')
  if vim.bo.buftype == 'terminal' then
    vim.g.last_term = term_bufnr
  end
end

-- Automatically save the buffer number of the last terminal when entering a terminal
vim.cmd([[
  augroup TerminalBufferTracking
    autocmd!
    autocmd TermEnter * lua Save_last_terminal_bufnr()
  augroup END
]])

-- lua print(vim.g.last_term)
-- lua print(vim.fn.bufnr('%'))
--vim.fn.bufnr('%')
