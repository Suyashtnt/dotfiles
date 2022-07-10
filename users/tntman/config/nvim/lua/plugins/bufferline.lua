local cp_api = require("catppuccin.api.colors")

require("bufferline").setup({
  diagnostic = "nvim_lsp",
  diagnostics_indicator = function(_, _, diagnostics_dict, _)
    local s = " "
    for e, n in pairs(diagnostics_dict) do
      local sym = e == "error" and " " or (e == "warning" and " " or "")
      s = s .. n .. sym
    end
    return s
  end,
  offsets = {
    {
      filetype = "neo-tree",
      text = function()
        return vim.fn.getcwd()
      end,
      highlight = "Directory",
      text_align = "left",
    },
  },
  custom_areas = {
    right = function()
      local result = {}
      local seve = vim.diagnostic.severity
      local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
      local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
      local info = #vim.diagnostic.get(0, { severity = seve.INFO })
      local hint = #vim.diagnostic.get(0, { severity = seve.HINT })

      if error ~= 0 then
        table.insert(result, { text = "  " .. error, guifg = cp_api.get_colors().red })
      end

      if warning ~= 0 then
        table.insert(result, { text = "  " .. warning, guifg = cp_api.get_colors().yellow })
      end

      if hint ~= 0 then
        table.insert(result, { text = "  " .. hint, guifg = cp_api.get_colors().blue })
      end

      if info ~= 0 then
        table.insert(result, { text = "  " .. info, guifg = cp_api.get_colors().text })
      end
      return result
    end,
  },
})
