require("sidebar-nvim").setup({
	open = false,
	bindings = {
		["q"] = function()
			require("sidebar-nvim").close()
		end,
	},
	datetime = {
		icon = "",
		format = "%a %b %d, %H:%M",
		clocks = {
			{ name = "local" },
		},
	},
	files = {
		icon = "",
		show_hidden = true,
		ignored_paths = { "%.git$" },
	},
	["git"] = {
		icon = "",
	},

	["diagnostics"] = {
		icon = "",
	},
	todos = {
		icon = "",
		ignored_paths = { "~" },
		initially_closed = false,
	},
	sections = { "datetime", "files", "symbols", "git", "diagnostics" },
})
