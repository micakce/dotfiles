vim.api.nvim_set_keymap('n', '<M-S>', "<cmd>lua OpenVerticalTerminal()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  'n',
  '<M-s>',
  'msvip<esc><cmd>lua CheckCurrentLine()<CR>`s',
  { noremap = true, silent = true }
)

function CheckCurrentLine()
  local line = vim.fn.getline('.')
  if line == '' then
    vim.cmd("TermExec cmd='%:p'")
  else
    vim.cmd("ToggleTermSendVisualLines 1024")
  end
end

local nnn = "<Cmd>lua require('lvim.core.terminal')._exec_toggle({ cmd = 'nnn', count = 102, direction = 'float' })<CR>"
vim.api.nvim_set_keymap('n', '<leader>n', nnn, { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-t>', '<CMD>ToggleTerm<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<M-t>', '<c-\\><c-n>:ToggleTerm<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-w>q', '<C-\\><C-n>', { noremap = true, silent = true })

function OpenVerticalTerminal()
  local winwidth = vim.api.nvim_win_get_width(0)
  local termwidth = math.floor(winwidth / 2)
  vim.cmd("1024ToggleTerm dir=%:p:h direction=vertical size=" .. termwidth)
  vim.cmd("stopinsert")
  vim.cmd("wincmd p")
end

function IsAnyVisibleBufferTerminal()
  local visible_bufs = vim.fn.filter(vim.fn.tabpagebuflist(vim.fn.tabpagenr()), 'v:lua.vim.fn.bufwinnr(v:val) != -1')
  for _, bufnr in ipairs(visible_bufs) do
    local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
    if buftype == 'terminal' then
      return true
    end
  end
  return false
end

-- Define a function to save the buffer number of the current terminal
function Save_last_terminal_bufnr()
  local term_bufnr = vim.fn.bufnr('%')
  if vim.bo.buftype == 'terminal' then
    vim.g.last_term = term_bufnr
  end
end

--
local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
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
  on_close = function(_)
    vim.cmd("startinsert!")
  end,
})

function LazygitToggle()
  lazygit:toggle()
end

lvim.builtin.which_key.mappings["g"]["g"] = { "<cmd>lua LazygitToggle()<CR>", "lg" }
