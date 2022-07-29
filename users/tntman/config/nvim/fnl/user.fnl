(local M {})
(set M.config
     (fn []
       (vim.api.nvim_set_keymap :n " " "" {})
       (set vim.g.mapleader " ")
       (set vim.opt.clipboard :unnamedplus)
       (set vim.opt.mouse :a)
       (set vim.g.neovide_transparency 0.8)
       (vim.cmd "    set nowrap
    set expandtab
    set tabstop=2
    set shiftwidth=2
  ")
       (set vim.wo.foldcolumn :1)
       (set vim.wo.foldlevel 99)
       (set vim.wo.foldenable true)
       (set vim.wo.number true)
       (set vim.wo.relativenumber true)
       (set vim.opt.termguicolors true)
       (set vim.opt.guifont "JetBrainsMono Nerd Font Complete:h9")
       (set vim.opt.laststatus 3)
       (set vim.opt.cmdheight 0)
       (set vim.g.coq_settings
            {:auto_start :shut-up :keymap {:jump_to_mark :null}})
       (set vim.g.catppuccin_flavour :mocha)
       (local signs {:Error " " :Warn " " :Hint " " :Info " "})
       (each [type icon (pairs signs)]
         (local hl (.. :DiagnosticSign type))
         (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl}))
       (set vim.g.markdown_fenced_languages {1 :ts=typescript})))
M
