lvim.builtin.which_key.mappings["D"] = {
  name = "Database",
  u = { "<Cmd>DBUIToggle<CR>", "Toggle UI" },
  f = { "<Cmd>DBUIFindBuffer<CR>", "Find buffer" },
  r = { "<Cmd>DBUIRenameBuffer<CR>", "Rename buffer" },
  q = { "<Cmd>DBUILastQueryInfo<CR>", "Last query info" },
}

lvim.builtin.which_key.mappings["f"] = {
  name = "FzfLua",
  f = { "<Cmd>FzfLua files<CR>", "Files" },
  r = { "<Cmd>FzfLua live_grep<CR>", "Grep" },
  R = { "<Cmd>FzfLua grep_last<CR>", "GrepLast" },
  l = { "<Cmd>FzfLua builtin<CR>", "List" },
  g = {
    name = "Git",
    b = { "<Cmd>FzfLua git_branches<CR>", "Gbranches" },
    c = { "<Cmd>FzfLua git_commits<CR>", "Gbcommits" },
    B = { "<Cmd>FzfLua git_branches<CR>", "Gbranches" },
    s = { "<Cmd>FzfLua git_status<CR>", "Gstatus" },
    t = { "<Cmd>FzfLua git_stash<CR>", "Gstash" },
  },
}
