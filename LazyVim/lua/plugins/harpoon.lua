return {
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<M-a>",
        function()
          require("harpoon.mark").add_file()
        end,
      },
      {
        "<M-h>",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
      },
      {
        "<M-1>",
        function()
          require("harpoon.ui").nav_file(1)
        end,
      },
      {
        "<M-2>",
        function()
          require("harpoon.ui").nav_file(2)
        end,
      },
      {
        "<M-3>",
        function()
          require("harpoon.ui").nav_file(3)
        end,
      },
      {
        "<M-4>",
        function()
          require("harpoon.ui").nav_file(4)
        end,
      },
      {
        "<M-5>",
        function()
          require("harpoon.ui").nav_file(5)
        end,
      },
      {
        "<M-6>",
        function()
          require("harpoon.ui").nav_file(6)
        end,
      },
      {
        "<M-7>",
        function()
          require("harpoon.ui").nav_file(7)
        end,
      },
      {
        "<M-7>",
        function()
          require("harpoon.ui").nav_file(7)
        end,
      },
      {
        "<M-{>",
        function()
          require("harpoon.ui").nav_next()
        end,
      },
      {
        "<M-}>",
        function()
          require("harpoon.ui").nav_prev()
        end,
      },
    },
  },
}

-- local mark = require("harpoon.mark")
-- local ui = require("harpoon.ui")
--
-- vim.keymap.set("n", "<m-h>", ui.toggle_quick_menu)
-- vim.keymap.set("n", "<m-1>", function()
--   ui.nav_file(1)
-- end)
-- vim.keymap.set("n", "<m-2>", function()
--   ui.nav_file(2)
-- end)
-- vim.keymap.set("n", "<m-3>", function()
--   ui.nav_file(3)
-- end)
-- vim.keymap.set("n", "<m-4>", function()
--   ui.nav_file(4)
-- end)
-- vim.keymap.set("n", "<m-5>", function()
--   ui.nav_file(5)
-- end)
-- vim.keymap.set("n", "<m-n>", ui.nav_next)
-- vim.keymap.set("n", "<m-p>", ui.nav_prev)
