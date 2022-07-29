local wk = require("which-key")

wk.register({
  name = "Cycles",
  ["]b"] = { "<Cmd>BufferLineCycleNext<CR>", "next buffer" },
  ["[b"] = { "<Cmd>BufferLineCyclePrev<CR>", "prev buffer" },
  ["<S-L>"] = { "<Cmd>BufferLineCycleNext<CR>", "next buffer" },
  ["<S-H>"] = { "<Cmd>BufferLineCyclePrev<CR>", "prev buffer" },
})
