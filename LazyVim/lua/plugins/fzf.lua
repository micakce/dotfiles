return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    requires = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    keys = {
      {
        "<leader>ff",
        function()
          require("fzf-lua").files()
        end,
        desc = "FzfFiles",
      },
      {
        "<leader>fb",
        function()
          require("fzf-lua").buffers()
        end,
        desc = "FzfBuffers",
      },
      {
        "<leader>fB",
        function()
          require("fzf-lua").blines()
        end,
        desc = "FzfBLines",
      },
      {
        "<leader>S",
        function()
          require("fzf-lua").builtin()
        end,
        desc = "FzfBuiltin",
      },
      {
        "<leader>fg",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "FzfGrep",
      },
      {
        "<leader>/",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "FZFLiveGrep",
      },
      {
        "<leader>fG",
        function()
          require("fzf-lua").grep_last()
        end,
        desc = "FzfGrepLast",
      },
    },
    config = function()
      local fzf_defaults = require("fzf-lua").defaults

      fzf_defaults.git.bcommits.actions = {
        ["default"] = require("fzf-lua").actions.git_buf_edit,
        ["ctrl-s"] = require("fzf-lua").actions.git_buf_split,
        ["ctrl-v"] = function(selected, _)
          local commit_hash = selected[1]:match("[^ ]+")
          local cmd = string.format("Gvdiffsplit %s", commit_hash)
          vim.cmd(cmd)
        end,
        ["ctrl-t"] = require("fzf-lua").actions.git_buf_tabedit,
      }

      vim.api.nvim_create_user_command("Lcommits", function(opts)
        vim.cmd("messages clear")
        for key, value in pairs(opts) do
          print("\t", key, value)
        end
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

      require("fzf-lua").setup(fzf_defaults)
    end,
  },
}
