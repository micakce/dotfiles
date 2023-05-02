-- Autocommands helper.
-- Modified from https://www.reddit.com/r/neovim/comments/t6sobd/smol_wrapper_around_lua_autocmd_api/
--
-- Example usage:
--
-- require("autocommands")("HighlightReferences")(function(autocmd)
--   autocmd("CursorHold", { buffer = bufnr }, function()
--     vim.lsp.buf.document_highlight()
--   end)
-- )
--
-- @param group The augroup name.
-- @param clear If true, clear the autogroup of any autocommands.
local au = function(group, clear)
  vim.api.nvim_create_augroup(group, { clear = clear or false })

  -- Return a closure.
  return function(autocmds)
    -- @param event The autocommand event.
    -- @param opts A table of options to pass to vim.api.nvim_create_autocmd
    -- @param command A string or function reference.
    autocmds(function(event, opts, command)
      opts.group = group

      -- Clear buffer-local autocommands.
      if opts.buffer ~= nil then
        vim.api.nvim_clear_autocmds({ event = event, group = opts.group, buffer = opts.buffer })
      elseif opts.pattern ~= nil then
        vim.api.nvim_clear_autocmds({ event = event, group = opts.group, pattern = opts.pattern })
      end

      if type(command) == "function" then
        opts.callback = command
      else
        opts.command = command
      end

      vim.api.nvim_create_autocmd(event, opts)
    end)
  end
end

return au
