local wk = require("which-key")

wk.register({
  l = { "<Cmd>BufferLineMoveNext<CR>", "move buffer ->" },
  h = { "<Cmd>BufferLineMovePrev<CR>", "move buffer <-" },
  d = { "<Cmd>bdelete<CR>", "delete current buffer" },
}, {
  prefix = "<leader>b",
})
