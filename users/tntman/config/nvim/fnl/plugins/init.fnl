(require-macros :macros.package-macros)

;; Setup packer
(let [packer (require :packer)]
  (packer.init {:git {:clone_timeout 300}
                :profile {:enable true}
                :display {:header_lines 2
                          :title " packer.nvim"
                          :open_fn (λ open_fn []
                                     (local {: float} (require :packer.util))
                                     (float {:border :solid}))}}))

(use-package! :wbthomason/packer.nvim)
(use-package! :rktjmp/hotpot.nvim {:branch :nightly})

;; funni icons
(use-package! :kyazdani42/nvim-web-devicons {:config (load-file devicons)})

;;  colourscheme
(use-package! :catppuccin/nvim {:as catppuccin :config (load-file catppuccin)})

;; the mightly statusline
(use-package! :rebelot/heirline.nvim {:config (load-file heirline)})

;; see every time you missed a semicolon
(use-package! :neovim/nvim-lspconfig
              {:after [:nvim-cmp :cmp-nvim-lsp]
               :config (load-file lsp)
               :requires [(pack :ray-x/lsp_signature.nvim)
                          (pack :simrat39/rust-tools.nvim)
                          (pack :jose-elias-alvarez/typescript.nvim)
                          (pack :SmiteshP/nvim-navic)
                          (pack :j-hui/fidget.nvim)
                          (pack :tamago324/nlsp-settings.nvim)
                          (pack :jose-elias-alvarez/null-ls.nvim)
                          (pack :b0o/schemastore.nvim)
                          (pack :kevinhwang91/nvim-ufo
                                {:requires [(pack :kevinhwang91/promise-async)]})
                          (pack :smjonas/inc-rename.nvim
                                {:config (call-setup :inc_rename)})]})

;; makes lisps not a pain
(use-package! :eraserhd/parinfer-rust {:opt true 
                                       :rtp :target/release
                                       :run "cargo build --release"})
(use-package! :harrygallagher4/nvim-parinfer-rust {:config (call-setup :parinfer)
                                                   :event :InsertEnter})

;; yuck support
(use-package! :elkowar/yuck.vim)

;; coq why did you not work anymore
(use-package! :hrsh7th/nvim-cmp
              {:requires [(pack :hrsh7th/cmp-path {:after :nvim-cmp})
                          (pack :hrsh7th/cmp-buffer {:after :nvim-cmp})
                          (pack :hrsh7th/cmp-cmdline {:after :nvim-cmp})
                          (pack :hrsh7th/cmp-nvim-lsp {:after :nvim-cmp})
                          (pack :saadparwaiz1/cmp_luasnip
                                {:after [:nvim-cmp :LuaSnip]})
                          (pack :L3MON4D3/LuaSnip {:as LuaSnip})
                          (pack :rafamadriz/friendly-snippets)]})

;; LSP-like support for Cargo.toml files
(use-package! :Saecki/crates.nvim
              {:tag :v0.2.1
               :requires [(pack :nvim-lua/plenary.nvim)]
               :config (load-file crates)})

;; <leader>q has never looked this good
(use-package! :kevinhwang91/nvim-bqf {:config (load-file bqf)})

;; when you really dislike telescope
(use-package! :junegunn/fzf
              {:run (fn []
                      ((. vim.fn "fzf#install")))})

;; see the thousands of keybinds vim has
(use-package! :folke/which-key.nvim {:config (call-setup :which-key)})

;; you see that bar with file names? Thats this
(use-package! :akinsho/bufferline.nvim
              {:tag :v2.* :config (load-file bufferline)})

;; you see those tab lines? Thats this
(use-package! :lukas-reineke/indent-blankline.nvim
              {:config (load-file indent_blankline)})

;; you see that syntax highlighting? Thats this
(use-package! :nvim-treesitter/nvim-treesitter
              {:requires [(pack :windwp/nvim-ts-autotag)
                          (pack :p00f/nvim-ts-rainbow)]
               :run ":TSUpdate"
               :config (load-file treesitter)})

;; <leader>ff and friends
(use-package! :nvim-telescope/telescope.nvim
              {:requires [(pack :nvim-lua/plenary.nvim)
                          (pack :nvim-telescope/telescope-file-browser.nvim)
                          (pack :nvim-telescope/telescope-media-files.nvim)
                          (pack :nvim-telescope/telescope-ghq.nvim)
                          (pack :jvgrootveld/telescope-zoxide)]
               :config (load-file telescope)})

;; autoclose ''
(use-package! :jiangmiao/auto-pairs)

;; a better % operator
(use-package! :andymass/vim-matchup)

;; stable :bdelete
(use-package! :famiu/bufdelete.nvim)

;; :Z and :Zi (requires zoxide to be installed)
(use-package! :nanotee/zoxide.vim)

;; makes splits easier to use
(use-package! :mrjones2014/smart-splits.nvim)

;; god. (I still need to setup this god)
(use-package! :ziontee113/syntax-tree-surfer)

;; also god.
(use-package! :kylechui/nvim-surround {:config (call-setup :nvim-surround)})

;; figure out why your code isn't doing what you told it to do
(use-package! :mfussenegger/nvim-dap {:config (load-file dap)})
(use-package! :rcarriga/nvim-dap-ui)
(use-package! :theHamsta/nvim-dap-virtual-text)
(use-package! :nvim-telescope/telescope-dap.nvim)

;; gcc and frens
(use-package! :numToStr/Comment.nvim {:config (load-file commenter)})
;; makes builtin UI look good
(use-package! :stevearc/dressing.nvim)
;; s/S amazingness
(use-package! :ggandor/leap.nvim {:config (load-file leap)})

;; makes rust errors readable
(use-package! "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
              {:config (load-file lsp_lines)})

;; file/buffer tree
(use-package! :nvim-neo-tree/neo-tree.nvim
              {:branch :v2.x
               :requires [(pack :nvim-lua/plenary.nvim)
                          (pack :kyazdani42/nvim-web-devicons)
                          (pack :MunifTanjim/nui.nvim)]})

;; automatically manage sessions as the same suggests
(use-package! :rmagatti/auto-session {:config (load-file autosession)})

;; show to the world that you are :nerd:
(use-package! :andweeb/presence.nvim {:config (load-file discord)})

;; notifications that look good
(use-package! :rcarriga/nvim-notify {:config (load-file notify)})

;; <leader>z to enter T H E C O D E Z O N E
(use-package! :folke/zen-mode.nvim {:config (load-file zenmode)})
(use-package! :folke/twilight.nvim {:config (load-file twilight)})

;; haha funni neovim logo
(use-package! :glepnir/dashboard-nvim {:config (load-file dashboard)})

;; At the end of the file, the unpack! macro is called to initialize packer and pass each package to the packer.nvim plugin.
(unpack!)
