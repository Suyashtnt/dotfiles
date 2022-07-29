(require-macros :fnl.macros.package-macros)

;; Setup packer
(let [packer (require :packer)]
  (packer.init {:git {:clone_timeout 300}
                :profile {:enable true}
                :autoremove true
                :compile_path (.. (vim.fn.stdpath :config)
                                  :/lua/packer_compiled.lua)
                :display {:header_lines 2
                          :title " packer.nvim"
                          :open_fn (λ open_fn []
                                     (local {: float} (require :packer.util))
                                     (float {:border :solid}))}}))

(use-package! :wbthomason/packer.nvim)
(use-package! :rktjmp/hotpot.nvim {:branch :nightly})

(use-package! :kyazdani42/nvim-web-devicons {:config (load-file devicons)})
;; funni icons

(use-package! :catppuccin/nvim {:as catppuccin :config (load-file catppuccin)})
;;  colourscheme

(use-package! :eraserhd/parinfer-rust {:opt true :run "cargo build --release"})
;; makes lisps better to use

(use-package! :rebelot/heirline.nvim {:config (load-file heirline)})

(use-package! :neovim/nvim-lspconfig
              {:requires [(pack :ray-x/lsp_signature.nvim)
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
                                {:config (fn []
                                           ((. (require :inc_rename) :setup)))})]
               :config (load-file lsp)})

(use-package! :Saecki/crates.nvim
              {:tag :v0.2.1
               :requires [(pack :nvim-lua/plenary.nvim)]
               :config (load-file crates)})

(use-package! :kevinhwang91/nvim-bqf {:config (load-file bqf)})

(use-package! :junegunn/fzf
              {:run (fn []
                      ((. vim.fn "fzf#install")))})

(use-package! :folke/which-key.nvim
              {:config (fn []
                         (. (require :which-key) :setup))})

(use-package! :akinsho/bufferline.nvim
              {:tag :v2.* :config (load-file bufferline)})

(use-package! :lukas-reineke/indent-blankline.nvim
              {:config (load-file indent_blankline)})

(use-package! :mrjones2014/legendary.nvim)

(use-package! :nvim-treesitter/nvim-treesitter
              {:requires [(pack :windwp/nvim-ts-autotag)
                          (pack :p00f/nvim-ts-rainbow)]
               :run ":TSUpdate"
               :config (load-file treesitter)})

(use-package! :nvim-telescope/telescope.nvim
              {:requires [(pack :nvim-lua/plenary.nvim)
                          (pack :nvim-telescope/telescope-file-browser.nvim)
                          (pack :nvim-telescope/telescope-media-files.nvim)
                          (pack :nvim-telescope/telescope-ghq.nvim)
                          (pack :jvgrootveld/telescope-zoxide)]
               :config (load-file telescope)})

(use-package! :ms-jpq/coq_nvim)
(use-package! :ms-jpq/coq.artifacts)
(use-package! :ms-jpq/coq.thirdparty)

(use-package! :jiangmiao/auto-pairs)
(use-package! :andymass/vim-matchup)
(use-package! :famiu/bufdelete.nvim)
(use-package! :nanotee/zoxide.vim)
(use-package! :alvan/vim-closetag)
(use-package! :mrjones2014/smart-splits.nvim)
(use-package! :ziontee113/syntax-tree-surfer)
(use-package! :tpope/vim-surround)

(use-package! :liuchengxu/vista.vim {:config (load-file vista)})

(use-package! :mfussenegger/nvim-dap {:config (load-file dap)})
(use-package! :rcarriga/nvim-dap-ui)
(use-package! :theHamsta/nvim-dap-virtual-text)
(use-package! :nvim-telescope/telescope-dap.nvim)

(use-package! :numToStr/Comment.nvim {:config (load-file commenter)})
(use-package! :stevearc/dressing.nvim)
(use-package! :ggandor/leap.nvim {:config (load-file leap)})

(use-package! "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
              {:config (load-file lsp_lines)})

(use-package! :nvim-neo-tree/neo-tree.nvim
              {:branch :v2.x
               :requires [(pack :nvim-lua/plenary.nvim)
                          (pack :kyazdani42/nvim-web-devicons)
                          (pack :MunifTanjim/nui.nvim)]})

(use-package! :rmagatti/auto-session {:config (load-file autosession)})

(use-package! :andweeb/presence.nvim {:config (load-file discord)})

(use-package! :rcarriga/nvim-notify {:config (load-file notify)})

(use-package! :folke/zen-mode.nvim {:config (load-file zenmode)})
(use-package! :folke/twilight.nvim {:config (load-file twilight)})
(use-package! :glepnir/dashboard-nvim {:config (load-file dashboard)})

;; At the end of the file, the unpack! macro is called to initialize packer and pass each package to the packer.nvim plugin.
(unpack!)
