local wk = require("which-key")

wk.register({
  e = { "<Cmd>Neotree filesystem toggle<CR>", "Open sidebar / file tree" },
  z = {
    function()
      require("zen-mode").toggle({
        window = {
          width = 0.80,
        },
      })
    end,
    "Enter the code zone (Zen mode)",
  },
}, {
  prefix = "<leader>",
})
