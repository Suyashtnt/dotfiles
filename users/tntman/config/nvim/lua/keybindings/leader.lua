local wk = require("which-key")

wk.register({
	e = { require("sidebar-nvim").toggle, "Open sidebar / file tree" },
	b = { "<Cmd>Telescope buffers<CR>", "Open buffer explorer" },
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
