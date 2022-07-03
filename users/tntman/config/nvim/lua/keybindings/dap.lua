local wk = require("which-key")
local dap = require("dap")

local function isempty(s)
	return s == nil or s == ""
end

wk.register({
	name = "+Debugging",
	c = {
		dap.continue,
		"Start/Continue Debugging",
	},
	b = {
		dap.toggle_breakpoint,
		"Toggle Breakpoint",
	},
	B = {
		function()
			vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
				if not isempty(input) then
					dap.set_breakpoint(input)
				end
			end)
		end,
		"Set Breakpoint Condition",
	},
	p = {
		function()
			vim.ui.input({ prompt = "Log point message: " }, function(input)
				if not isempty(input) then
					dap.set_breakpoint(nil, nil, input)
				end
			end)
		end,
		"Set Log Point",
	},
	e = {
		dap.repl.open,
		"Evaluate Expression",
	},
	l = {
		dap.run_last,
		"Evaluate Last Expression",
	},
	o = {
		require("dapui").toggle,
		"Toggle DAP UI",
	},
	s = {
		name = "+Step",
		o = {
			dap.step_over,
			"Step Over",
		},
		i = {
			dap.step_into,
			"Step Into",
		},
	},
}, {
	prefix = "<leader>d",
})
