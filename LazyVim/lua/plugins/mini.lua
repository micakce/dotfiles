return {
  {
    "nvim-mini/mini.files",
    version = "*",
    config = function()
      require("mini.files").setup()
    end,
    keys = {
      {
        "<M-o>",
        mode = { "n" },
        function()
          require("mini.files").open()
        end,
        desc = "Open Mini Files",
      },
    },
  },
}
