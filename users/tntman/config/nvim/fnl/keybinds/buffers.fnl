(local reg (. (require :which-key) :register))

(reg {:l [:<Cmd>BufferLineMoveNext<CR> "move buffer right"]
      :h [:<Cmd>BufferLineMovePrev<CR> "move buffer left"]
      :d [:<Cmd>bdelete<CR> "delete current buffer"]} {:prefix :<leader>b})
