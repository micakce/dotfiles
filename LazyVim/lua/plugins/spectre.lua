return {
  {
    "nvim-pack/nvim-spectre",
    config = function()
      require("spectre").setup({
        highlight = {
          ui = "String",
          search = "BufferInactiveTarget",
          replace = "DiffText",
        },
      })
    end,
  },
}
