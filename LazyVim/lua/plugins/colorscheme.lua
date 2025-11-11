return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-latte",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      integrations = {
        -- keep your integrations here if you use any
      },
      custom_highlights = function(colors)
        return {
          -- Make cursor highly visible
          Cursor = { fg = colors.base, bg = colors.red, bold = true },
          CursorLine = { bg = colors.surface1 },
          CursorLineNr = { fg = colors.red, bold = true },
        }
      end,
    },
  },
}
