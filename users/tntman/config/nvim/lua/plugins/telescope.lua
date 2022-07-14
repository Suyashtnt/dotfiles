require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

require("telescope").load_extension("file_browser")
require("telescope").load_extension("notify")
require("telescope").load_extension("media_files")
require("telescope").load_extension("ghq")
require("telescope").load_extension("zoxide")
