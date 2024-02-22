require("arena").setup({
    -- Maxiumum number of files that the arena window can contain, or `nil` for
    -- an unlimited amount
    max_items = 10,
    -- Always show the enclosing folder for these paths
    always_context = { "mod.rs", "init.lua", "go.mod" },
    -- When set, ignores the current buffer when listing files in the window.
    ignore_current = false,
    -- Options to apply to the arena buffer.
    -- Format should be `["<OPTION>"] = <VALUE>`
    buf_opts = {
        -- Example. Uncomment to add to your config!
        -- ["relativenumber"] = false,
    },
    -- Filter out buffers per the project they belong to.
    per_project = false,


    window = {
        width = 60,
        height = 10,
        border = "rounded",

        -- Options to apply to the arena window.
        opts = {},
    },

    -- Keybinds for the arena window.
    keybinds = {
        -- Example. Uncomment to add to your config!
        -- ["e"] = function()
        --   vim.cmd("echo \"Hello from the arena!\"")
        -- end
    },

    -- Config for frecency algorithm.
    algorithm = {
        -- Multiplies the recency by a factor. Must be greater than zero.
        -- A smaller number will mean less of an emphasis on recency!
        recency_factor = 0.5,
        -- Same as `recency_factor`, but for frequency!
        frequency_factor = 1,
    },
})


require("which-key").register({
    ["<M-l>"] = { "<cmd>lua require('arena').toggle()<CR>", "Toggle Arena" },
})
