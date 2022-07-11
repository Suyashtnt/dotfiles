local wk = require("which-key")

wk.register({
	e = { "<Cmd>Neotree filesystem toggle<CR>", "Toggle sidebar / file tree" },
	o = { "<Cmd>Vista<CR>", "Toggle vista / code outliner" },
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
