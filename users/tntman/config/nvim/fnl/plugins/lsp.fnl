(local lspconfig (require :lspconfig))
(local coq (require :coq))
(local navic (require :nvim-navic))
(local nlspsettings (require :nlspsettings))

(nlspsettings.setup {:config_home (.. (vim.fn.stdpath :config) :/nlsp-settings)
                     :local_settings_dir :.nlsp-settings
                     :local_settings_root_markers {1 :.git}
                     :append_default_schemas true
                     :loader :json})

((. (require :fidget) :setup) {})

(local global-capabilities (vim.lsp.protocol.make_client_capabilities))
(set global-capabilities.textDocument.completion.completionItem.snippetSupport
     true)
(set global-capabilities.textDocument.foldingRange
     {:dynamicRegistration false :lineFoldingOnly true})
(set lspconfig.util.default_config
     (vim.tbl_extend :force lspconfig.util.default_config
                     {:capabilities global-capabilities}))

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

    (vim.keymap.set :n :gD vim.lsp.buf.declaration bufopts)
    (vim.keymap.set :n :gd vim.lsp.buf.definition bufopts)
    (vim.keymap.set :n :K vim.lsp.buf.hover bufopts)
    (vim.keymap.set :n :gi vim.lsp.buf.implementation bufopts)
    (vim.keymap.set :n :<space>wa vim.lsp.buf.add_workspace_folder bufopts)
    (vim.keymap.set :n :<space>wr vim.lsp.buf.remove_workspace_folder bufopts)
    (vim.keymap.set :n :<space>wl
                    (fn []
                      (print (vim.inspect (vim.lsp.buf.list_workspace_folders))))
                    bufopts)
    (vim.keymap.set :n :<space>D vim.lsp.buf.type_definition bufopts)
    (vim.keymap.set :n :<leader>rn
                    (fn []
                      ((. (require :inc_rename) :rename) {:default (vim.fn.expand :<cword>)}))
                    bufopts)
    (vim.keymap.set :n :<space>ca vim.lsp.buf.code_action bufopts)
    (vim.keymap.set :n :gr vim.lsp.buf.references bufopts)
    (vim.api.nvim_create_autocmd :CursorHold
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
                                                (set vim.b.diagnostics_pos
                                                     [nil nil]))
                                              (local cursor-pos
                                                     (vim.api.nvim_win_get_cursor 0))
                                              (when (and (or (not= (. cursor-pos
                                                                      1)
                                                                   (. vim.b.diagnostics_pos
                                                                      1))
                                                             (not= (. cursor-pos
                                                                      2)
                                                                   (. vim.b.diagnostics_pos
                                                                      2)))
                                                         (> (length (vim.diagnostic.get))
                                                            0))
                                                (vim.diagnostic.open_float nil
                                                                           cursor-hold-opts))
                                              (set vim.b.diagnostics_pos
                                                   cursor-pos))})))

(local orig-util-open-floating-preview vim.lsp.util.open_floating_preview)
(fn vim.lsp.util.open_floating_preview [contents syntax internal-opts ...]
  (set-forcibly! internal-opts (or internal-opts {}))
  (set internal-opts.border :rounded)
  (orig-util-open-floating-preview contents syntax internal-opts ...))

((require :coq_3p) [{:src :bc :short_name :MATH :precision 6} {:src :dap}])

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

((. (require :rust-tools) :setup) (coq.lsp_ensure_capabilities {:server {:on_attach (on-attach true
                                                                                               true)}}))

((. (require :typescript) :setup) (coq.lsp_ensure_capabilities {:disable_commands false
                                                                :debug false
                                                                :server {:on_attach (on-attach true
                                                                                               false)}}))

(lspconfig.sumneko_lua.setup (coq.lsp_ensure_capabilities {:on_attach (on-attach true
                                                                                 false)
                                                           :settings {:Lua {:diagnostics {:globals {1 :vim}}
                                                                            :runtime {:version :LuaJIT
                                                                                      :path (vim.split package.path
                                                                                                       ";")}
                                                                            :workspace {:library (vim.api.nvim_get_runtime_file ""
                                                                                                                                true)}}}}))

(lspconfig.jsonls.setup (coq.lsp_ensure_capabilities {:on_attach (on-attach true
                                                                            true)
                                                      :settings {:json {:schemas ((. (. (require :schemastore)
                                                                                        :json)
                                                                                     :schemas))
                                                                        :validate {:enable true}}}}))

(lspconfig.yamlls.setup (coq.lsp_ensure_capabilities {:on_attach (on-attach true
                                                                            true)
                                                      :settings {:yaml {:schemastore {:enable true}}}}))

(lspconfig.volar.setup (coq.lsp_ensure_capabilities {:filetypes {1 :typescript
                                                                 2 :javascript
                                                                 3 :javascriptreact
                                                                 4 :typescriptreact
                                                                 5 :vue
                                                                 6 :json}
                                                     :on_attach (on-attach false
                                                                           false)}))

(lspconfig.prismals.setup (coq.lsp_ensure_capabilities {:on_attach (on-attach true
                                                                              true)}))

(lspconfig.taplo.setup (coq.lsp_ensure_capabilities {:on_attach (on-attach true
                                                                           true)}))

(lspconfig.rnix.setup (coq.lsp_ensure_capabilities {:on_attach (on-attach false
                                                                          true)}))

(lspconfig.svelte.setup (coq.lsp_ensure_capabilities {:on_attach (on-attach false
                                                                            false)}))

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
