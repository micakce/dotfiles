local fzf_defaults = require("fzf-lua").defaults

fzf_defaults.git.bcommits.actions = {
	["default"] = require("fzf-lua").actions.git_buf_edit,
	["ctrl-s"] = require("fzf-lua").actions.git_buf_split,
	["ctrl-d"] = function(selected, _)
		local commit_hash = selected[1]:match("[^ ]+")
		local cmd = string.format("lua require('gitsigns').diffthis('%s')", commit_hash)
		vim.cmd(cmd)
	end,
	["ctrl-v"] = function(selected, _)
		local commit_hash = selected[1]:match("[^ ]+")
		local cmd = string.format("Gvdiffsplit %s", commit_hash)
		vim.cmd(cmd)
	end,
	["ctrl-t"] = require("fzf-lua").actions.git_buf_tabedit,
}

vim.api.nvim_create_user_command("Lcommits", function(opts)
	-- vim.cmd("messages clear")
	-- for key, value in pairs(opts) do
	--   print("\t", key, value)
	-- end
	local start_line = opts.line1
	local end_line = opts.line2
	require("fzf-lua").git_bcommits({
		prompt = "LCommits> ",
		cmd = "git log "
			.. opts.args
			.. " --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))"
			.. "%Creset %s %C(blue)<%an>%Creset' -L "
			.. start_line
			.. ","
			.. end_line
			.. ":<file> --no-patch",
	})
end, {
	nargs = "*",
	range = true,
	force = true,
})

require("which-key").register({
	["<leader>f"] = {
		name = "+files",
		f = { "<cmd>FzfLua files<CR>", "files" },
		b = { "<cmd>FzfLua buffers<CR>", "buffers" },
		B = { "<cmd>FzfLua blines<CR>", "blines" },
		g = { "<cmd>FzfLua live_grep<CR>", "grep" },
	},
	["<leader>S"] = { "<cmd>FzfLua builtin<CR>", "cmd_list" },
	["<leader>/"] = { "<cmd>FzfLua live_grep<CR>", "grep" },
	["<leader>\\"] = { "<cmd>FzfLua grep_last<CR>", "grep_last" },
})
