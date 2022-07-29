(local setup (. (require :catppuccin) :setup))
(local intergrations {:treesitter true
                      :native_lsp {:enabled true
                                   :virtual_text {:errors [:italic]
                                                  :hints [:italic]
                                                  :warnings [:italic]
                                                  :information [:italic]}
                                   :underlines {:errors [:underline]
                                                :hints [:underline]
                                                :warnings [:underline]
                                                :information [:underline]}}
                      :cmp false
                      :lsp_saga true
                      :gitgutter true
                      :gitsigns true
                      :telescope true
                      :nvimtree {:enabled false
                                 :show_root false
                                 :transparent_panel false}
                      :neotree {:enabled true
                                :show_root true
                                :transparent_panel true}
                      :which_key true
                      :indent_blankline {:enabled true
                                         :colored_indent_levels true}
                      :dashboard true
                      :neogit false
                      :vim_sneak false
                      :fern false
                      :barbar false
                      :bufferline true
                      :markdown true
                      :leap true
                      :ts_rainbow true
                      :hop false
                      :notify true
                      :telekasten true
                      :symbols_outline false})

(setup {1 intergrations})
(set vim.g.catppuccin_flavour :mocha)
(vim.cmd "colorscheme catppuccin")
