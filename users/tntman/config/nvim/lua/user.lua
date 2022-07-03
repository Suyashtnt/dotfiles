local M = {}

M.config = function()
	-- general settings
	vim.api.nvim_set_keymap("n", " ", "", {})
	vim.g.neovide_transparency = 0.9
	vim.g.mapleader = " "
	vim.opt.clipboard = "unnamedplus"
	vim.opt.mouse = "a"

	vim.cmd('set nowrap')

	-- folding
	vim.wo.foldcolumn = "1"
	vim.wo.foldlevel = 99 -- feel free to decrease the value
	vim.wo.foldenable = true

	-- display stuff
	vim.wo.number = true
	vim.wo.relativenumber = true
	vim.opt.termguicolors = true
	vim.opt.guifont = "JetBrainsMono Nerd Font Complete:h9"
	vim.opt.laststatus = 3
	vim.opt.cmdheight = 0

	-- plugin global settings
	vim.g.coq_settings = {
		["auto_start"] = "shut-up",
		["keymap"] = {
			["jump_to_mark"] = "null",
		},
	}
	vim.g.catppuccin_flavour = "mocha"

	-- diagnostics signs
	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	-- for deno lsp
	vim.g.markdown_fenced_languages = {
		"ts=typescript",
	}
end

return M
