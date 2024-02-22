local ls = require "luasnip"
ls.parser.parse_snippet({ trig = "lsp" }, "$1 is ${2|hard,easy,challenging|}")
