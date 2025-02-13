local M = {}

-- Function to extend text motions with custom logic
function M.transform_with_dynamic_motion(transform_fn)
  -- Prompt for motion
  local motion = vim.fn.input("Enter motion: ")

  if motion == "" then
    print("No motion entered")
    return
  end

  -- Execute the motion in visual mode
  vim.cmd("normal! v" .. motion)

  -- Get the visual range
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- Extract lines within the range
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  -- Apply the transformation
  lines = transform_fn(lines)

  -- Replace the lines in the buffer
  vim.fn.setline(start_pos[2], lines)

  -- Clear visual selection
  vim.cmd("normal! gv")
end

function M._reverse_text(lines)
  for i, line in ipairs(lines) do
    lines[i] = line:reverse()
  end
  return lines
end

function M.reverse_text()
  M.transform_with_dynamic_motion(M._reverse_text)
end

return M
