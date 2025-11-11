return {
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   opts = {
  --     strategies = {
  --       -- Change the default chat adapter and model
  --       chat = {
  --         adapter = "openai",
  --         model = "GPT-5",
  --       },
  --     },
  --     -- NOTE: The log_level is in `opts.opts`
  --     opts = {
  --       log_level = "DEBUG",
  --     },
  --   },
  --
  --   config = function(_, opts)
  --     vim.keymap.set("n", "<LocalLeader>d", function()
  --       require("codecompanion").prompt("~/prompts/default")
  --     end, { noremap = true, silent = true })
  --   end,
  -- },
  {
    "johnseth97/codex.nvim",
    lazy = true,
    cmd = { "Codex", "CodexToggle" }, -- Optional: Load only on command execution
    keys = {
      {
        "<M-x>", -- Change this to your preferred keybinding
        function()
          require("codex").toggle()
        end,
        mode = { "n", "i" },
        desc = "Toggle Codex popup",
      },
    },
    opts = {
      keymaps = {
        toggle = nil, -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
        quit = "<M-x>", -- Keybind to close the Codex window (default: Ctrl + q)
      }, -- Disable internal default keymap (<leader>cc -> :CodexToggle)
      border = "rounded", -- Options: 'single', 'double', or 'rounded'
      width = 0.8, -- Width of the floating window (0.0 to 1.0)
      height = 0.8, -- Height of the floating window (0.0 to 1.0)
      model = nil, -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
      autoinstall = true, -- Automatically install the Codex CLI if not found
    },
  },
}
