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

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", function()
	vim.diagnostic.setqflist({ open = true })
end, opts)

-- custom on_attach
local function on_attach(useNavic, formatting)
	return function(client, bufnr)
		if formatting == false then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

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

		local bufopts = { noremap = true, silent = true, buffer = bufnr }

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)

		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, bufopts)

		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
		vim.keymap.set("n", "<leader>rn", function()
			require("inc_rename").rename({ default = vim.fn.expand("<cword>") })
		end, bufopts)
		vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)

		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			callback = function()
				local cursorHoldOpts = {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					border = "rounded",
					source = "always", -- show source in diagnostic popup window
					prefix = " ",
				}

				if not vim.b.diagnostics_pos then
					vim.b.diagnostics_pos = { nil, nil }
				end

				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				if
					(cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
					and #vim.diagnostic.get() > 0
				then
					vim.diagnostic.open_float(nil, cursorHoldOpts)
				end

				vim.b.diagnostics_pos = cursor_pos
			end,
		})
	end
end

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, internalOpts, ...)
	internalOpts = internalOpts or {}
	internalOpts.border = "rounded"
	return orig_util_open_floating_preview(contents, syntax, internalOpts, ...)
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
local ca = nullls.builtins.code_actions

nullls.setup({
	sources = {
		formatting.stylua,
		diagnostics.eslint,
		formatting.eslint_d,
		ca.eslint,
	},
	on_attach = on_attach(false, true),
})

-- Plugin based
require("rust-tools").setup(coq.lsp_ensure_capabilities({
	server = {
		on_attach = on_attach(true, true),
	},
}))

require("typescript").setup(coq.lsp_ensure_capabilities({
	disable_commands = false,
	debug = false,
	server = {
		on_attach = on_attach(true, false),
	},
}))

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

lspconfig.volar.setup(coq.lsp_ensure_capabilities({
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
	on_attach = on_attach(false, false),
}))

-- generic setups
lspconfig.prismals.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach(true, true) }))
lspconfig.taplo.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach(true, true) }))
lspconfig.rnix.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach(false, true) }))
lspconfig.svelte.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach(false, false) }))

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
