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
      vim.keymap.set("t", "<c-n>", "<c-\\><c-n>", {})
      vim.keymap.set("t", "<M-t>", "<c-\\><c-n>:ToggleTerm direction=float<CR>", {})
    end,
    event = "VimEnter",
    keys = {
      {
        "<M-s>",
        "msvip<esc><cmd>lua SendOrExecuteInTerm()<CR>`s",
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
      {
        "<M-t>",
        function()
          vim.cmd("ToggleTerm direction=float")
        end,
      },
    },
  },
}
