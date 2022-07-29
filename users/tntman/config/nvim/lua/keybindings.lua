require("legendary").setup({
  autocmds = {
    {
      name = "LspOnAttachAutocmds",
      clear = true,
      {
        "BufWritePre",
        vim.lsp.buf.format,
      },
    },
  },
  commands = {
    {
      ":Format",
      vim.lsp.buf.format,
      description = "Format the current document",
    },
    {
      "PS",
      "PackerSync",
      description = "Update packer plugins",
    },
  },
})

local scan = require("plenary.scandir")
for _, file in ipairs(scan.scan_dir(os.getenv("HOME") .. "/.config/nvim/lua/keybindings", { depth = 0 })) do
  dofile(file)
end
