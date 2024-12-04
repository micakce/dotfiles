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
        line = line .. " `" .. json_tag .. "`"
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
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<leader>tj",
      "<cmd>lua add_json_tag(false)<CR>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(0, "v", "<leader>tj", ":lua add_json_tag(true)<CR>", { noremap = true, silent = true })
  end,
})
