function SendOrExecuteInTerm()
  ---@diagnostic disable-next-line: param-type-mismatch
  local line = vim.fn.getline(".")
  if line == "" then
    vim.cmd("TermExec cmd='%:p'")
  else
    vim.cmd("ToggleTermSendVisualLines 1024")
  end
end

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup()

      local Terminal = require("toggleterm.terminal").Terminal
      local nnn = Terminal:new({
        cmd = "nnn",
        direction = "float",
        float_opts = {
          border = "double",
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function NNNToggle(dir)
        if dir ~= nil and arg ~= "" then
          nnn.dir = dir
        else
          nnn.dir = vim.api.nvim_call_function("getcwd", {})
        end
        nnn:toggle()
      end

      local lazygit = Terminal:new({
        cmd = "lazygit",
        direction = "float",
        float_opts = {
          border = "double",
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function LazygitToggle(dir)
        if dir ~= nil and arg ~= "" then
          lazygit.dir = dir
        else
          lazygit.dir = vim.api.nvim_call_function("getcwd", {})
        end
        lazygit:toggle()
      end

      -- vim.keymap.set("t", "<c-n>", "<c-\\><c-n>", {})
      vim.api.nvim_set_keymap(
        "n",
        "<M-t>",
        "<CMD>lua <<EOF\nlocal count = tonumber(vim.v.count) or 1\nvim.cmd(count..'ToggleTerm direction=float')\nEOF<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "t",
        "<M-t>",
        "<c-\\><c-n>:ToggleTerm direction=float<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>lua NNNToggle()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>N", '<cmd>lua NNNToggle("%:p:h")<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua LazygitToggle()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>gG",
        '<cmd>lua LazygitToggle("%:p:h")<CR>',
        { noremap = true, silent = true }
      )
    end,
    event = "VimEnter",
    keys = {
      {
        "<M-e>",
        "<CMD>w | TermExec cmd='%:p'<CR>",
      },
      {
        "<M-s>",
        "msvip<esc><cmd>lua SendOrExecuteInTerm()<CR>`s",
      },
      {
        "v",
        "<M-s>",
        "<CMD>ToggleTermSendVisualSelection 1024<CR>",
      },
      {
        "<M-S>",
        function()
          local winwidth = vim.api.nvim_win_get_width(0)
          local termwidth = math.floor(winwidth / 2)
          vim.cmd("1024ToggleTerm dir=%:p:h direction=vertical size=" .. termwidth)
          vim.cmd("stopinsert")
          vim.cmd("wincmd p")
        end,
      },
    },
  },
}
