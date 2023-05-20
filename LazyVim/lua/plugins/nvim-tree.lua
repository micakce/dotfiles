return {
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        -- sync_root_with_cwd = true,
        disable_netrw = true,
        filesystem_watchers = {
          enable = false,
        },
        -- reload_on_bufenter = true,
        -- root_dirs = { ".git", "go.mod" },
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      })

      local nvimTreeGroup = vim.api.nvim_create_augroup("BufEnter", { clear = true })
      function Change_directory()
        local target_files = { ".git" }
        local current_directory = vim.fn.expand("%:p:h")

        -- Check current directory and parent directories
        local directory = current_directory
        while directory ~= "/" do
          for _, file in ipairs(target_files) do
            local full_path = directory .. "/" .. file
            local path_exists = vim.loop.fs_stat(full_path)
            if path_exists and path_exists.type then
              vim.cmd("cd " .. directory)
              return
            end
          end

          directory = vim.fn.fnamemodify(directory, ":h")
        end
      end
      vim.api.nvim_create_autocmd("BufEnter", {
        command = "lua Change_directory()",
        group = nvimTreeGroup,
      })

      vim.keymap.set("n", "<leader>e", "<CMD>NvimTreeToggle<CR>", {})
      vim.keymap.set("n", "<leader>%", "<CMD>NvimTreeFocus<CR>", {})
    end,
  },
}
