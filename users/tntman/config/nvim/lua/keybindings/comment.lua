local wk = require("which-key")

wk.register({
	name = "Comments",
	c = "Toggle comment linewise",
	o = "comment and insert",
	O = "comment and insert back",
	A = "comment and insert EOL",
}, {
	prefix = "gc",
})

wk.register({
	name = "Comments",
	c = "Toggle comment blockwise",
}, {
	prefix = "gb",
})
