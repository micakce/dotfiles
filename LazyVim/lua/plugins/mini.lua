return {
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "ys",
        delete = "ysd",
        find = "ysf",
        find_left = "ysfh",
        highlight = "ysh",
        replace = "ysr",
        update_n_lines = "ysn",
      },
    },
  },
  {
    "echasnovski/mini.files",
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
