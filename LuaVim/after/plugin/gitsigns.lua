require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		gs.toggle_current_line_blame()

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]h", function()
			if vim.wo.diff then
				return "]h"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[h", function()
			if vim.wo.diff then
				return "[h"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		local wk = require("which-key")
		wk.register({
			["<leader>h"] = {
				name = "+hunks",
				s = { gs.stage_hunk, "stage" },
				r = { gs.reset_hunk, "reset" },
				S = { gs.stage_buffer, "stage" },
				u = { gs.undo_stage_hunk, "unstage" },
				R = { gs.reset_buffer, "reset" },
				p = { gs.preview_hunk, "preview" },
				b = { gs.blame_line, "blame" },
				d = { gs.diffthis, "diff" },
			},
			["<leader>tb"] = { gs.toggle_current_line_blame, "toggle_blame" },
			["<leader>td"] = { gs.toggle_deleted, "toggle_deleted" },
		}, { mode = "n" })

		wk.register({
			["<leader>hs"] = { gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }), "" },
			["<leader>hr"] = { gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }), "" },
		}, { mode = "v" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
