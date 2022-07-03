local wk = require("which-key")

wk.register({
	-- That one Telescope config every single person and their childern are using
	name = "+Find",
	f = { "<Cmd>Telescope find_files find_command=rg,--hidden,--files<CR>", "files" },
	b = { "<Cmd>Telescope buffers<CR>", "buffers" },
	h = { "<Cmd>Telescope help_tags<CR>", "help tags" },
	c = {
		name = "+Commands",
		c = { "<Cmd>Telescope commands<CR>", "commands" },
		h = { "<Cmd>Telescope command_history<CR>", "history" },
	},
	q = { "<Cmd>Telescope quickfix<CR>", "quickfix" },
	g = {
		name = "+Git",
		g = { "<Cmd>Telescope git_commits<CR>", "commits" },
		c = { "<Cmd>Telescope git_bcommits<CR>", "bcommits" },
		b = { "<Cmd>Telescope git_branches<CR>", "branches" },
		s = { "<Cmd>Telescope git_status<CR>", "status" },
	},
	w = { "<Cmd>Telescope workspaces<CR>", "workspaces" },
}, {
	prefix = "<leader>f",
})
