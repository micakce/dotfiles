local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    "tsserver",
    "rust_analyzer",
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    -- ["<C-Space>"] = cmp.mapping.complete(),
})

-- cmp_mappings["<Tab>"] = nil
-- cmp_mappings["<S-Tab>"] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = "E",
        warn = "W",
        hint = "H",
        info = "I",
    },
})

lsp.on_attach(function(client, bufnr)
    -- if vim.bo.ft == "go" then
    -- 	local LSP_Go = vim.api.nvim_create_augroup("LSP_Go", {})
    -- 	local autocmd = vim.api.nvim_create_autocmd
    -- 	autocmd("BufWritePre", {
    -- 		group = LSP_Go,
    -- 		pattern = "*",
    -- 		callback = function()
    -- 			vim.lsp.buf.format()
    -- 		end,
    -- 	})
    -- end

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)
    vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<CR>", opts)
    vim.keymap.set("n", "gI", "<cmd>FzfLua lsp_implementations<CR>", opts)
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set("n", "<leader>vws", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", opts)
    vim.keymap.set("n", "<leader>vd", function()
        vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.goto_next()
    end, opts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.goto_prev()
    end, opts)
    vim.keymap.set("n", "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<leader>cr", function()
        vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
    end, opts)
end)

lsp.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ["lua_ls"] = { "lua" },
        ["gopls"] = { "go" },
    },
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
