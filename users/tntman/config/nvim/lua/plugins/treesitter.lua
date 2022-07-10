require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  -- for plugin windwp/nvim-ts-autotag
  autotag = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
  },
})
