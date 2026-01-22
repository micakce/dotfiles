local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node

-- /////////////
-- // Title   //
-- /////////////
ls.add_snippets("all", {
  s("boxc", {
    f(function(args)
      local title = args[1][1] or ""
      -- "// " + title + " //"  => 4 extra chars + title length
      return string.rep("/", #title + 6)
    end, { 1 }),
    t({ "", "// " }),
    i(1, "Title"),
    t({ " //", "" }),
    f(function(args)
      local title = args[1][1] or ""
      return string.rep("/", #title + 6)
    end, { 1 }),
  }),
})
