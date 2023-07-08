-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<ESC>", {})
vim.keymap.set("t", "<c-q>", "<c-\\><c-n>", {})
vim.keymap.set("t", "<c-h>", "<c-\\><c-n><c-w>h", {})
vim.keymap.set("t", "<c-j>", "<c-\\><c-n><c-w>j", {})
vim.keymap.set("t", "<c-k>", "<c-\\><c-n><c-w>k", {})
vim.keymap.set("t", "<c-l>", "<c-\\><c-n><c-w>l", {})

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
