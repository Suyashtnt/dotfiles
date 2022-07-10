-- imports
local lspconfig = require("lspconfig")
local coq = require("coq")
local navic = require("nvim-navic")
local nlspsettings = require("nlspsettings")

-- Setup nlsp
nlspsettings.setup({
  config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
  local_settings_dir = ".nlsp-settings",
  local_settings_root_markers = { ".git" },
  append_default_schemas = true,
  loader = "json",
})

require("navigator").setup({})

-- Cool LSP status thing in bottom right corner
require("fidget").setup({})

-- Allow snippets in all files
local global_capabilities = vim.lsp.protocol.make_client_capabilities()
global_capabilities.textDocument.completion.completionItem.snippetSupport = true
global_capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  capabilities = global_capabilities,
})

-- custom on_attach
local function on_attach(useNavic, formatting)
  return function(client, bufnr)
    if formatting == false then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    require("navigator.lspclient.mapping").setup({
      client = client,
      bufnr = bufnr,
      cap = client.server_capabilities,
    })

    -- makes the signature help popup look baie cooletjies (Very cool)
    require("lsp_signature").on_attach({
      bind = true,
      handler_opts = {
        border = "rounded",
      },
    }, bufnr)

    if useNavic == true then
      navic.attach(client, bufnr)
    end
  end
end

-- coq extra stuff
require("coq_3p")({
  { src = "bc", short_name = "MATH", precision = 6 },
  { src = "dap" },
})

-- LSP setups
local nullls = require("null-ls")

local formatting = nullls.builtins.formatting
local diagnostics = nullls.builtins.diagnostics

nullls.setup({
  sources = {
    formatting.stylua,
    diagnostics.eslint
  },
  on_attach = on_attach(false, true),
})

-- Plugin based
require("rust-tools").setup(coq.lsp_ensure_capabilities({
  server = {
    on_attach = on_attach(true, true),
  },
}))

require("typescript").setup({
  disable_commands = false,
  debug = false,
  server = {
    on_attach = on_attach(true, false),
  },
})

-- Custom configs
lspconfig.sumneko_lua.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach(true, false),
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}))

lspconfig.jsonls.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach(true, true),
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}))

lspconfig.yamlls.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach(true, true),
  settings = {
    yaml = {
      schemastore = {
        enable = true,
      },
    },
  },
}))

lspconfig.eslint.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach(false, true),
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
  },
  settings = {
    autoFixOnSave = true,
    format = { enable = true },
  },
}))

-- generic setups
lspconfig.prismals.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach(true, true) }))
lspconfig.taplo.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach(true, true) }))
lspconfig.rnix.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach(false, true) }))
lspconfig.svelte.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach(false, false) }))
lspconfig.volar.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach(false, false) }))

local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

require("ufo").setup({
  fold_virt_text_handler = ufo_handler,
})
