local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "nvim-lua/plenary.nvim" },
    { "neovim/nvim-lspconfig" },

    --------
    -- BIG 3
    --------

    --------
    -- FOLKE
    --------
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
            {
                "S",
                mode = { "n", "o", "x" },
                function() require("flash").treesitter() end,
                desc =
                "Flash Treesitter"
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc =
                "Remote Flash"
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc =
                "Treesitter Search"
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc =
                "Toggle Flash Search"
            },
        },
    },
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    { "folke/neodev.nvim" },
    { "folke/zen-mode.nvim" },
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({ icons = false })
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    -----------
    -- junegunn
    -----------
    { "junegunn/fzf",               build = "./install --bin" },
    {
        "junegunn/vim-easy-align",
        config = function()
            vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", {})
            vim.api.nvim_set_keymap("n", "ga", "<Plug>(EasyAlign)", {})
        end,
    },
    { "ibhagwan/fzf-lua" },

    -----------
    -- tpope
    -----------
    { "tpope/vim-fugitive",         lazy = false,             cmd = { "G" } },
    { "tpope/vim-abolish" },

    { "nvim-tree/nvim-web-devicons" },
    {
        "nvim-lualine/lualine.nvim",
        config = true,
        requires = { "nvim-tree/nvim-web-devicons", opt = true },
    },
    { "nvim-tree/nvim-tree.lua" },
    { "nvim-pack/nvim-spectre" },
    { "renerocksai/telekasten.nvim" },

    -----------
    -- mini
    -----------
    { "echasnovski/mini.surround" },
    -- stylua: ignore
    { "echasnovski/mini.pairs",     version = "*", config = function() require("mini.pairs").setup() end },
    {
        'echasnovski/mini.files',
        version = '*',
        config = function() require("mini.files").setup() end,
        keys = {
            {
                "<M-o>",
                mode = { "n" },
                function() require("mini.files").open() end,
                desc = "Open Mini Files"
            },
        }
    },


    {
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.0",
        -- or                            , branch = '0.1.x',
        requires = { { "nvim-lua/plenary.nvim" } },
    },
    {
        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end,
    },
    { "nvim-treesitter/nvim-treesitter-context" },
    { "nvim-treesitter/playground" },

    { "wellle/targets.vim" },
    { "echasnovski/mini.pairs",                 version = "*" },

    { "lewis6991/gitsigns.nvim" },

    { "theprimeagen/harpoon" },
    { "theprimeagen/refactoring.nvim" },
    { "mbbill/undotree" },

    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },
    { "rafamadriz/friendly-snippets" },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        },
    },
    { "github/copilot.vim" },
    { "eandrju/cellular-automaton.nvim" },
    { "laytan/cloak.nvim" },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        event = "VimEnter",
    },
    { "christoomey/vim-tmux-navigator" },
    {
        "terrortylor/nvim-comment",
        config = function()
            require("nvim_comment").setup()
        end,
    },
    {
        "dzfrias/arena.nvim",
        event = "BufWinEnter",
        -- Calls `.setup()` automatically
        config = true,
        keys = {
            {
                "<M-l>",
                mode = { "n" },
                function() require("arena").toggle() end,
                desc =
                "Toggle Flash Search"
            },
        }
    },
    {
        "brenton-leighton/multiple-cursors.nvim",
        config = true,
        keys = {
            { "<C-Down>",      "<Cmd>MultipleCursorsAddDown<CR>",        mode = { "n", "i" } },
            { "<C-Up>",        "<Cmd>MultipleCursorsAddUp<CR>",          mode = { "n", "i" } },
            { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" } },
        },
    }
})
