local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local local_packer = nil

if fn.empty(fn.glob(install_path)) > 0 then
	local_packer = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

require("packer").init({
	autoremove = true,
})

return require("packer").startup(function(use) -- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("plugins.devicons")
		end,
	}) -- Icons n stuff

	use({
		"suyashtnt/nvim-1",
		branch = "feature/leap",
		as = "catppuccin",
		config = function()
			require("plugins.catppuccin")
		end,
	}) -- Colourscheme

	use({
		"rebelot/heirline.nvim",
		config = function()
			require("plugins.heirline")
		end,
	}) -- (win|status)bar

	use({
		"neovim/nvim-lspconfig",
		requires = { -- All plugins used/using LSP stuff
			"ray-x/guihua.lua",
			run = "cd lua/fzy && make", -- UI libs navigator uses
			"ray-x/lsp_signature.nvim", -- Signature hints
			"simrat39/rust-tools.nvim", -- Extra rust utils/support
			"jose-elias-alvarez/typescript.nvim", -- Better typescript support
			"SmiteshP/nvim-navic", -- Where you are in the document, initialzed via LSP
			"j-hui/fidget.nvim", -- Nicer LSP status
			"tamago324/nlsp-settings.nvim", -- LSP settings
			"jose-elias-alvarez/null-ls.nvim", -- Generic formatting and stuff
			"b0o/schemastore.nvim", -- Plugin for better JSON autocomplete
			{ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" }, -- code folding but better
			{
				"smjonas/inc-rename.nvim",
				config = function()
					require("inc_rename").setup()
				end,
			}, -- LSP incremental rename
		},
		config = function()
			require("plugins.lsp")
		end,
	}) -- Makes LSPs not a pain to look setup

	use({
		"Saecki/crates.nvim",
		tag = "v0.2.1",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.crates")
		end,
	}) -- Crates.io support

	use({
		"kevinhwang91/nvim-bqf",
		config = function()
			require("plugins.bqf")
		end,
	}) -- makes quickfix look godlike

	use({
		"junegunn/fzf",
		run = function()
			vim.fn["fzf#install"]()
		end,
	}) -- funni fzf

	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup()
		end,
	}) -- UI for keybinds

	use({
		"akinsho/bufferline.nvim",
		tag = "v2.*",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("plugins.bufferline")
		end,
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugins.indent_blankline")
		end,
	})

	use({ "mrjones2014/legendary.nvim" }) -- Keybinding manager/lookup(<leader><Shift-k>)

	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			"windwp/nvim-ts-autotag", -- auto close html tags and stuff
			"p00f/nvim-ts-rainbow",
		},
		run = ":TSUpdate",
		config = function()
			require("plugins.treesitter")
		end,
	}) -- the all-mighty treesitter

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"nvim-telescope/telescope-ghq.nvim",
			"jvgrootveld/telescope-zoxide",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
		config = function()
			require("plugins.telescope")
		end,
	}) -- file picker and other stuff

	use("ms-jpq/coq_nvim") -- autocomplete on some steroids
	use("ms-jpq/coq.artifacts") -- Snippets
	use("ms-jpq/coq.thirdparty") -- Custom extensions

	use("jiangmiao/auto-pairs") -- auto pairs
	use({ "andymass/vim-matchup", event = "VimEnter" }) -- bracket auto close
	use("famiu/bufdelete.nvim") -- better buffer deletion
	use("nanotee/zoxide.vim") -- zoxide support
	use("alvan/vim-closetag") -- auto close HTML tags
	use("mrjones2014/smart-splits.nvim") -- smarter spliting and stuff
	use("ziontee113/syntax-tree-surfer") -- treesitter syntax finder
	use({
		"liuchengxu/vista.vim",
		config = function()
			require("plugins.vista")
		end,
	}) -- code outliner

	use({
		"mfussenegger/nvim-dap",
		config = function()
			require("plugins.dap")
		end,
	}) -- debugging momen

	use({ "rcarriga/nvim-dap-ui" }) -- vscode debugger UI
	use("theHamsta/nvim-dap-virtual-text") -- virtual text for debugging
	use("nvim-telescope/telescope-dap.nvim") -- I forgor what this does

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("plugins.commenter")
		end,
	}) -- `gc` commenting plugin

	use("stevearc/dressing.nvim") -- make builtin UI look good

	use({
		"ggandor/leap.nvim",
		config = function()
			require("plugins.leap")
		end,
	}) -- replaces the s/S key with a super-powered quicksearch

	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	}) -- file tree

	use({
		"rmagatti/auto-session",
		config = function()
			require("plugins.autosession")
		end,
	})

	use("tpope/vim-surround") -- Surround text with ease

	use({
		"andweeb/presence.nvim",
		config = function()
			require("plugins.discord")
		end,
	}) --  Discord Rich Presence

	use({
		"rcarriga/nvim-notify",
		config = function()
			require("plugins.notify")
		end,
	}) -- better notification handler

	use({
		"folke/zen-mode.nvim",
		config = function()
			require("plugins.zenmode")
		end,
	}) -- enter t h e c o d e z o n e

	use({
		"folke/twilight.nvim",
		config = function()
			require("plugins.twilight")
		end,
	}) -- dim everything except for the code portion you are working on. Helps with t h e c o d e z o n e

	use({
		"glepnir/dashboard-nvim",
		config = function()
			require("plugins.dashboard")
		end,
	}) -- startup dashboard thingy

	-- first time install thing
	if local_packer then
		require("packer").sync()
	end
end)
