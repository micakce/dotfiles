-- <M-s> <M-t>

--

-- lvim.keys.normal_mode["<M-S>"] = "<cmd>1024ToggleTerm dir=%:p:h direction=vertical size=60<cr>"
-- lvim.keys.normal_mode["<M-s>"] = "msvip<esc><cmd>ToggleTermSendVisualLines 1024<CR>`s"
vim.api.nvim_set_keymap('n', '<M-S>', "<cmd>lua OpenVerticalTerminal()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-s>', "msvip<esc><cmd>ToggleTermSendVisualLines 1024<CR>`s",
  { noremap = true, silent = true })
local nnn = "<Cmd>lua require('lvim.core.terminal')._exec_toggle({ cmd = 'nnn', count = 102, direction = 'float' })<CR>"
vim.api.nvim_set_keymap('n', '<leader>n', nnn, { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-t>', '<CMD>ToggleTerm<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<M-t>', '<c-\\><c-n>:ToggleTerm<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-w>q', '<C-\\><C-n>', { noremap = true, silent = true })
-- lvim.builtin.which_key.mappings["n"] = { nnn, "nnn" }

function OpenVerticalTerminal()
  -- if not IsAnyVisibleBufferTerminal() then
  local winwidth = vim.api.nvim_win_get_width(0)
  local termwidth = math.floor(winwidth / 2)
  vim.cmd("1024ToggleTerm dir=%:p:h direction=vertical size=" .. termwidth)
  vim.cmd("stopinsert")
  vim.cmd("wincmd p")
  -- end
  -- vim.cmd("normal! msvip:ToggleTermSendVisualLines 1024<CR>`s'")
end

-- function Send_lines_to_terminal()
--   if vim.g.last_term == nil then
--     local winwidth = vim.api.nvim_win_get_width(0)
--     local termwidth = math.floor(winwidth / 2)
--     vim.cmd("1024ToggleTerm dir=%:p:h direction=vertical size=" .. termwidth)
--     vim.cmd("stopinsert")
--     vim.cmd("wincmd p")
--   else
--     if not Buffer_is_visible(vim.g.last_term) then
--       local winwidth = vim.api.nvim_win_get_width(0)
--       local termwidth = math.floor(winwidth / 2)
--       vim.cmd("1024ToggleTerm dir=%:p:h direction=vertical size=" .. termwidth)
--       vim.cmd("stopinsert")
--       vim.cmd("wincmd p")
--     end
--   end
--   vim.cmd("normal! vip")
--   vim.cmd("ToggleTermSendVisualLines 1024")
-- end

function Send_paragraph_to_term()
  -- Open the terminal using toggleTerm

  -- Calculate the width of the terminal to be 50% of the window width

  -- Open the terminal using toggleTerm with the calculated width
  -- vim.cmd(vim.g.last_term .. "ToggleTerm dir=%:p:h direction=vertical size=" .. termwidth)

  -- Send the paragraph to the terminal
  vim.cmd(":SendVisualLinesToTerminal<CR>")
end

function Buffer_is_visible(bufnr)
  for tabnr = 1, vim.fn.tabpagenr("$") do
    for winid, bufid in pairs(vim.fn.tabpagebuflist(tabnr)) do
      if bufid == bufnr then
        return true
      end
    end
  end
  return false
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

-- -- Automatically save the buffer number of the last terminal when entering a terminal
-- vim.cmd([[
--   augroup TerminalBufferTracking
--     autocmd!
--     autocmd TermEnter * lua Save_last_terminal_bufnr()
--   augroup END
-- ]])

-- lua print(vim.g.last_term)
-- lua print(vim.fn.bufnr('%'))
--vim.fn.bufnr('%')
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
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})

function _lazygit_toggle()
  lazygit:toggle()
end

lvim.builtin.which_key.mappings["g"]["g"] = { "<cmd>lua _lazygit_toggle()<CR>", "lg" }
