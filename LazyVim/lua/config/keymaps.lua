-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

function Lua_Send_to_tmux(count)
  vim.cmd('normal! "zyip')
  local _count = (count == 0) and "top-right" or tostring(count)
  local text = vim.fn.getreg("z")
  text = text:gsub("\n", "\r"):gsub("'", "'\"'\"'")
  os.execute("tmux send-keys -t " .. _count .. " '" .. text .. "' Enter")
end

function Lua_Visual_Send_to_tmux(count)
  vim.cmd('normal! gv"zy')
  local _count = (count == 0) and "top-right" or tostring(count)
  local text = vim.fn.getreg("z")
  text = text:gsub("\n", "\r"):gsub("'", "'\"'\"'")
  os.execute("tmux send-keys -t " .. _count .. " '" .. text .. "' Enter")
end

vim.api.nvim_set_keymap("n", "<M-m>", ":lua Lua_Send_to_tmux(vim.v.count)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "v",
  "<M-m>",
  ":lua Lua_Visual_Send_to_tmux(vim.v.count)<CR>",
  { noremap = true, silent = true }
)
vim.keymap.set("i", "jk", "<ESC>", {})
vim.keymap.set("t", "<c-q>", "<c-\\><c-n>", {})
vim.keymap.set("t", "<c-h>", "<c-\\><c-n><c-w>h", {})
vim.keymap.set("t", "<c-j>", "<c-\\><c-n><c-w>j", {})
vim.keymap.set("t", "<c-k>", "<c-\\><c-n><c-w>k", {})
vim.keymap.set("t", "<c-l>", "<c-\\><c-n><c-w>l", {})

vim.keymap.set("n", "<c-h>", "<CMD>TmuxNavigateLeft<CR>", {})
vim.keymap.set("n", "<c-j>", "<CMD>TmuxNavigateDown<CR>", {})
vim.keymap.set("n", "<c-k>", "<CMD>TmuxNavigateUp<CR>", {})
vim.keymap.set("n", "<c-l>", "<CMD>TmuxNavigateRight<CR>", {})

-- Abbrev
vim.cmd([[abbrev i!=  if err != nil {<ENTER>]])
vim.cmd([[abbrev <=  <%= %><left><left><left>]])
vim.cmd([[abbrev <%  <% %><left><left><left>]])

vim.keymap.set("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true })

vim.keymap.set("n", "cc", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_cc'
  else
    return "cc"
  end
end, { expr = true })

vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true })

vim.cmd([[
nnoremap <expr>  <Space>r ReplaceWithPlusRegister()
xnoremap <expr>  <Space>r ReplaceWithPlusRegister()

function! ReplaceWithPlusRegister(type='') abort
  if a:type == ''
    set opfunc=ReplaceWithPlusRegister
    return 'g@'
  endif

  let sel_save = &selection
  let reg_save = getreginfo('"')
  let cb_save = &clipboard
  let visual_marks_save = [getpos("'<"), getpos("'>")]
  echom visual_marks_save

  try
    set clipboard= selection=inclusive
    let commands = #{line: "'[V']\"_dO", char: "`[v`]\"_d", block: "`[\<c-v>`]\"_d"}
    silent exe 'noautocmd keepjumps normal! ' .. get(commands, a:type, '')
    exec 'normal ""P'
  finally
    call setreg('"', reg_save)
    call setpos("'<", visual_marks_save[0])
    call setpos("'>", visual_marks_save[1])
    let &clipboard = cb_save
    let &selection = sel_save
  endtry
endfunction
]])

vim.cmd([[
nnoremap <expr>  <Space>b BreakInside()
xnoremap <expr>  <Space>b BreakInside()
function! BreakInside(type='') abort
  if a:type == ''
    set opfunc=BreakInside
    return 'g@'
  endif

  let sel_save = &selection
  let reg_save = getreginfo('"')
  let cb_save = &clipboard
  let visual_marks_save = [getpos("'<"), getpos("'>")]

  try
    " Preserve clipboard and selection options
    set clipboard= selection=inclusive

    " Define commands for different selection types
    let commands = #{line: "'[V']d", char: "`[v`]d", block: "`[\<c-v>`]d"}
    " Yank the selected text (y instead of d to copy instead of delete)
    silent exe 'noautocmd keepjumps normal! ' .. get(commands, a:type, '')

    " Get the yanked text from the unnamed register
    let yanked_text = getreg('"')

    " Perform the replacement on the yanked text (replace commas with newlines)
    let modified_text = substitute(yanked_text, '^', "\n", 'g')
    let modified_text = substitute(modified_text, '$', ", ", 'g')
    let modified_text = substitute(modified_text, ',', ",\n", 'g')

    " Paste the modified text
    call setreg('"', modified_text)
    exec 'normal! ""Pmb=ap`b' | delmarks b

  finally
    " Restore register, clipboard, selection, and visual marks
    call setreg('"', reg_save)
    call setpos("'<", visual_marks_save[0])
    call setpos("'>", visual_marks_save[1])
    let &clipboard = cb_save
    let &selection = sel_save
  endtry
endfunction
]])
