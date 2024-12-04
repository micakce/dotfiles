vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")

-- Abbrev
vim.cmd([[abbrev i!=  if err != nil {<ENTER>]])
vim.cmd([[abbrev <=  <%= %><left><left><left>]])
vim.cmd([[abbrev <%  <% %><left><left><left>]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

--vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
--vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/dotfiles/LuaVim/after/plugin/<CR>")
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

-- vim.keymap.set("n", "<leader><leader>", function()
--     vim.cmd("source")
-- end)

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
    exec 'normal! ""P=ap'

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

local function add_json_tag(is_visual)
    -- local mode = vim.fn.mode()
    local start, finish

    -- Check if we are in visual mode
    if is_visual then
        start = vim.fn.line("'<")
        finish = vim.fn.line("'>")
    else
        -- If not, just work on the current line
        start = vim.fn.line(".")
        finish = start
    end

    for i = start, finish do
        local line = vim.fn.getline(i)
        local field_name = line:match("%s*(%w+)%s+%w+%s*")

        if field_name then
            -- local json_tag = 'json:"' .. field_name:lower() .. '"'
            local json_tag = 'json:"' .. field_name:sub(1, 1):lower() .. field_name:sub(2) .. '"'


            -- Check if there's already a tag section (` `)
            if line:match("`") then
                -- If tags exist, add the JSON tag within the backticks
                line = line:gsub("`", "` " .. json_tag .. " ", 1)
            else
                -- If no tags exist, add a new tag section with backticks
                line = line .. ' `' .. json_tag .. '`'
            end

            vim.fn.setline(i, line)
        end
    end
end

-- Set up the mapping for Go files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        -- Map the function to a key combination, e.g., <leader>j
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>tj", "<cmd>lua add_json_tag(false)<CR>",
            { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "v", "<leader>tj", ":lua add_json_tag(true)<CR>",
            { noremap = true, silent = true })
    end
})
