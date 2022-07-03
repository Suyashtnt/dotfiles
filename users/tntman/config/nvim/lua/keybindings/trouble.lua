local wk = require("which-key")

-- adapted from docs
wk.register({
	name = "+Trouble",
	x = { "<Cmd>TroubleToggle<CR>", "Toggle" },
	w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
	d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfixes" },
	l = { "<cmd>TroubleToggle loclist<cr>", "Quickfix location list" },
}, {
	prefix = "<leader>x",
})
