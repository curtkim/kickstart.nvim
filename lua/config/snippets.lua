local ls = require 'luasnip'
-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

local date = function()
  return { os.date '%Y-%m-%d' }
end

ls.config.set_config {
  store_selection_keys = '<c-s>',
}

ls.add_snippets(nil, {
  all = {
    snip({
      trig = 'date',
      namr = 'Date',
      dscr = 'Date in the form of YYYY-MM-DD',
    }, {
      func(date, {}),
    }),

    snip({
      trig = 'meta',
      namr = 'Metadata',
      dscr = 'Yaml metadata format for markdown',
    }, {
      text { '---', 'title: ' },
      insert(1, 'note_title'),
      text { '', 'author: ' },
      insert(2, 'author'),
      text { '', 'date: ' },
      func(date, {}),
      text { '', 'categories: [' },
      insert(3, ''),
      text { ']', 'lastmod: ' },
      func(date, {}),
      text { '', 'tags: [' },
      insert(4),
      text { ']', 'comments: true', '---', '' },
      insert(0),
    }),

    snip({
      trig = 'link',
      namr = 'markdown_link',
      dscr = 'Create markdown link [txt](url)',
    }, {
      text '[',
      insert(1),
      text '](',
      func(function(_, snippet)
        return snippet.env.TM_SELECTED_TEXT[1] or {}
      end, {}),
      text ')',
      insert(0),
    }),
  },
})
