local wk = require("which-key")

wk.register({
  name = "Legendary",
  l = {
    function()
      require("legendary").find()
    end,
    "Find All",
  },
  k = {
    function()
      require("legendary").find("keymaps")
    end,
    "Find Keymaps",
  },
  c = {
    function()
      require("legendary").find("commands")
    end,
    "Find Commands",
  },
  a = {
    function()
      require("legendary").find("autocmds")
    end,
    "Find Autocmds",
  },
}, {
  prefix = "<leader><S-k>",
})
