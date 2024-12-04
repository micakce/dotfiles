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
    on_close = function(_)
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
    on_close = function(_)
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

function SendOrExecuteInTerm()
    ---@diagnostic disable-next-line: param-type-mismatch
    local line = vim.fn.getline(".")
    if line == "" then
        vim.cmd("TermExec cmd='%:p'")
    else
        vim.cmd("ToggleTermSendVisualLines 1024")
    end
end

function OpenTerm1024()
    local winwidth = vim.api.nvim_win_get_width(0)
    local termwidth = math.floor(winwidth / 2)
    vim.cmd("1024ToggleTerm dir=%:p:h direction=vertical size=" .. termwidth)
    vim.cmd("stopinsert")
    vim.cmd("wincmd p")
end

vim.api.nvim_set_keymap("n", "<M-e>", "<CMD>w | TermExec cmd='%:p'<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-s>", "msvip<esc><CMD>lua SendOrExecuteInTerm()<CR>`s", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<M-s>", "<CMD>ToggleTermSendVisualSelection 1024<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-S>", "<CMD>lua  OpenTerm1024()<CR>", { noremap = true, silent = true })


function Lua_Send_to_tmux(count)
    vim.cmd('normal! "zyip')
    local _count = (count == 0) and "bottom-right" or tostring(count)
    local text = vim.fn.getreg("z")
    text = text:gsub("\n", "\r"):gsub("'", "'\"'\"'")
    -- os.execute("tmux send-keys -Rt " .. _count .. " '" .. text .. "' Enter")
    os.execute("tmux send-keys -t " .. _count .. " '" .. text .. "' Enter")
end

vim.api.nvim_set_keymap("n", "<M-m>", "<CMD>Lua_Send_to_tmux(vim.v.count)<CR>", { noremap = true, silent = true })


vim.api.nvim_set_keymap("t", "<c-\\>", "<c-\\><c-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-h>", "<c-\\><c-n>:wincmd h<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-l>", "<c-\\><c-n><c-l>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-j>", "<c-\\><c-n><c-j>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-k>", "<c-\\><c-n><c-k>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
    "n",
    "<M-t>",
    "<CMD>lua <<EOF\nlocal count = tonumber(vim.v.count) or 1\nvim.cmd(count..'ToggleTerm direction=float')\nEOF<CR>",
    { noremap = true, silent = true }
)
vim.cmd("autocmd BufWinEnter,WinEnter term://* startinsert")

vim.api.nvim_set_keymap("t", "<M-t>", "<c-\\><c-n>:ToggleTerm direction=float<CR>", { noremap = true, silent = true })
require("which-key").register({
    ["<leader>n"] = { "<cmd>lua NNNToggle()<CR>", "NNN" },
    ["<leader>N"] = { '<cmd>lua NNNToggle("%:p:h")<CR>', "NNN(cwd)" },
    ["<leader>gg"] = { "<cmd>lua LazygitToggle()<CR>", "Lgit" },
    ["<leader>gG"] = { '<cmd>lua LazygitToggle("%:p:h")<CR>', "Lgit(cwd)" },
})
