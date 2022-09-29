(local lspc (require :lspconfig))
(local navic (require :nvim-navic))
(local nlspsettings (require :nlspsettings))
(local cmp (require :cmp))
(local luasnip (require :luasnip))

(set vim.opt.completeopt [:menu :menuone :noselect])

;; default icons (lspkind)
(local icons {:Text ""
              :Method ""
              :Function ""
              :Constructor "⌘"
              :Field "ﰠ"
              :Variable ""
              :Class "ﴯ"
              :Interface ""
              :Module ""
              :Unit "塞"
              :Property "ﰠ"
              :Value ""
              :Enum ""
              :Keyword "廓"
              :Snippet ""
              :Color ""
              :File ""
              :Reference ""
              :Folder ""
              :EnumMember ""
              :Constant ""
              :Struct "פּ"
              :Event ""
              :Operator ""
              :TypeParameter ""})

(cmp.setup {:experimental {:ghost_text true}
            :window {:documentation {:border :rounded}
                     :completion {:border :rounded}}
            :preselect cmp.PreselectMode.None
            :snippet {:expand (fn [args]
                                (luasnip.lsp_expand args.body))}
            :mapping (cmp.mapping.preset.insert {
                                                 :<C-b> (cmp.mapping.scroll_docs -4) 
                                                 :<C-f> (cmp.mapping.scroll_docs 4)
                                                 :<C-Space> (cmp.mapping.complete)
                                                 :<C-e> (cmp.mapping.abort)
                                                 :<CR> (cmp.mapping.confirm {:select true})})
                                                                                             
            :sources [{:name :nvim_lsp}
                      {:name :luasnip}
                      {:name :crates}
                      {:name :buffer}
                      {:name :path}]
            :formatting {:fields [:kind :abbr :menu]
                         :format (fn [_ vim-item]
                                   (set vim-item.menu vim-item.kind)
                                   (set vim-item.kind (. icons vim-item.kind))
                                   vim-item)}})

;; Enable command-line completions
(cmp.setup.cmdline "/" {:mapping (cmp.mapping.preset.cmdline)
                        :sources [{:name :buffer}]})

;; Enable search completions
(cmp.setup.cmdline ":"
                   {:mapping (cmp.mapping.preset.cmdline)
                    :sources [{:name :path} {:name :cmdline}]})

;; snippets
((. (require :luasnip.loaders.from_vscode) :lazy_load))

(nlspsettings.setup {:config_home (.. (vim.fn.stdpath :config) :/nlsp-settings)
                     :local_settings_dir :.nlsp-settings
                     :local_settings_root_markers {1 :.git}
                     :append_default_schemas true
                     :loader :json})

((. (require :fidget) :setup) {})

(local global-capabilities
       ((. (require :cmp_nvim_lsp) :update_capabilities) (vim.lsp.protocol.make_client_capabilities)))

(set global-capabilities.textDocument.completion.completionItem.snippetSupport
     true)

(set global-capabilities.textDocument.foldingRange
     {:dynamicRegistration false :lineFoldingOnly true})

(local signs {:Error " " :Warn " " :Hint " " :Info " "})
(each [type icon (pairs signs)]
  (local hl (.. :DiagnosticSign type))
  (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl}))

(local opts {:noremap true :silent true})

(vim.keymap.set :n "[d" vim.diagnostic.goto_prev opts)
(vim.keymap.set :n "]d" vim.diagnostic.goto_next opts)
(vim.keymap.set :n :<space>q
                (fn []
                  (vim.diagnostic.setqflist {:open true})) opts)

(fn on-attach [use-navic formatting]
  (fn [client bufnr]
    (when (= formatting false)
      (set client.server_capabilities.documentFormattingProvider false)
      (set client.server_capabilities.documentRangeFormattingProvider false))
    ((. (require :lsp_signature) :on_attach) {:bind true
                                              :handler_opts {:border :rounded}}
                                             bufnr)
    (when (= use-navic true)
      (navic.attach client bufnr))
    (local bufopts {:noremap true :silent true :buffer bufnr})

    (fn merge-table [table1 table2]
      (each [_ value (ipairs table2)]
        (tset table1 (+ (length table1) 1) value))
      table1)

    (fn setn [map func]
      (vim.keymap.set :n map func bufopts))

    (setn :gd vim.lsp.buf.definition)
    (setn :K vim.lsp.buf.hover)
    (setn :gi vim.lsp.buf.implementation)
    (setn :<space>wa vim.lsp.buf.add_workspace_folder)
    (setn :<space>wr vim.lsp.buf.remove_workspace_folder)
    (setn :<space>wl
          #(print (vim.inspect (vim.lsp.buf.list_workspace_folders))))
    (setn :<space>D vim.lsp.buf.type_definition)
    (setn :<leader>rn #(.. ":IncRename " (vim.fn.expand :<cword>)))
    (setn :<space>ca vim.lsp.buf.code_action)
    (setn :gr vim.lsp.buf.references)
    (local acmd vim.api.nvim_create_autocmd)
    (acmd :CursorHold
          {:buffer bufnr
           :callback (fn []
                       (local cursor-hold-opts
                              {:focusable false
                               :close_events [:BufLeave
                                              :CursorMoved
                                              :InsertEnter
                                              :FocusLost]
                               :border :rounded
                               :source :always
                               :prefix " "})
                       (when (not vim.b.diagnostics_pos)
                         (set vim.b.diagnostics_pos [nil nil]))
                       (local cursor-pos (vim.api.nvim_win_get_cursor 0))
                       (when (and (or (not= (. cursor-pos 1)
                                            (. vim.b.diagnostics_pos 1))
                                      (not= (. cursor-pos 2)
                                            (. vim.b.diagnostics_pos 2)))
                                  (> (length (vim.diagnostic.get)) 0))
                         (vim.diagnostic.open_float nil cursor-hold-opts))
                       (set vim.b.diagnostics_pos cursor-pos))})))

(local nullls (require :null-ls))
(local formatting nullls.builtins.formatting)
(local diagnostics nullls.builtins.diagnostics)
(local ca nullls.builtins.code_actions)

(local eslint-settings {:extra_filetypes [:javascript
                                          :javascriptreact
                                          :typescript
                                          :typescriptreact
                                          :vue
                                          :svelte]})

(nullls.setup {:sources [formatting.stylua
                         (diagnostics.eslint_d.with eslint-settings)
                         (formatting.eslint_d.with eslint-settings)
                         (ca.eslint_d.with eslint-settings)]
               :on_attach (on-attach false true)})

((. (require :rust-tools) :setup) {:server {:on_attach (on-attach true true)
                                            :capabilities global-capabilities}})

((. (require :typescript) :setup) {:disable_commands false
                                   :debug false
                                   :server {:on_attach (on-attach true false)
                                            :capabilities global-capabilities}})

(lspc.sumneko_lua.setup {:on_attach (on-attach true false)
                         :capabilities global-capabilities
                         :settings {:Lua {:diagnostics {:globals [:vim]}
                                          :runtime {:version :LuaJIT
                                                    :path (vim.split package.path
                                                                     ";")}
                                          :workspace {:library (vim.api.nvim_get_runtime_file ""
                                                                                              true)}}}})

(lspc.jsonls.setup {:on_attach (on-attach true true)
                    :capabilities global-capabilities
                    :settings {:json {:schemas ((. (. (require :schemastore)
                                                      :json)
                                                   :schemas))
                                      :validate {:enable true}}}})

(lspc.yamlls.setup {:on_attach (on-attach true true)
                    :capabilities global-capabilities
                    :settings {:yaml {:schemastore {:enable true}}}})

(lspc.volar.setup {:filetypes [:typescript
                               :javascript
                               :javascriptreact
                               :typescriptreact
                               :vue
                               :json]
                   :capabilities global-capabilities
                   :on_attach (on-attach false false)})

(lspc.prismals.setup {:on_attach (on-attach true true)
                      :capabilities global-capabilities})

(lspc.taplo.setup {:on_attach (on-attach true true)
                   :capabilities global-capabilities})

(lspc.rnix.setup {:on_attach (on-attach false true)
                  :capabilities global-capabilities})

(lspc.svelte.setup {:on_attach (on-attach false false)
                    :capabilities global-capabilities})

(fn ufo-handler [virt-text lnum end-lnum width truncate]
  (let [new-virt-text {}]
    (var suffix (: "  %d " :format (- end-lnum lnum)))
    (local suf-width (vim.fn.strdisplaywidth suffix))
    (local target-width (- width suf-width))
    (var cur-width 0)
    (each [_ chunk (ipairs virt-text)]
      (var chunk-text (. chunk 1))
      (var chunk-width (vim.fn.strdisplaywidth chunk-text))
      (if (> target-width (+ cur-width chunk-width))
          (table.insert new-virt-text chunk)
          (do
            (set chunk-text (truncate chunk-text (- target-width cur-width)))
            (local hl-group (. chunk 2))
            (table.insert new-virt-text {1 chunk-text 2 hl-group})
            (set chunk-width (vim.fn.strdisplaywidth chunk-text))
            (when (< (+ cur-width chunk-width) target-width)
              (set suffix
                   (.. suffix
                       (: " " :rep (- (- target-width cur-width) chunk-width)))))
            (lua :break)))
      (set cur-width (+ cur-width chunk-width)))
    (table.insert new-virt-text {1 suffix 2 :MoreMsg})
    new-virt-text))

((. (require :ufo) :setup) {:fold_virt_text_handler ufo-handler})
