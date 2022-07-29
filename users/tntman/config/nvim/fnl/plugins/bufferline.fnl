(local colors ((. (require :catppuccin.palettes) :get_palette)))
(local setup (. (require :bufferline) :setup))

(setup {:diagnostic :nvim_lsp
        :diagnostics_indicator (fn [_ _ diagnostics-dict _]
                                 (var s " ")
                                 (each [e n (pairs diagnostics-dict)]
                                   (local sym
                                          (or (and (= e :error) " ")
                                              (or (and (= e :warning) " ")
                                                  "")))
                                   (set s (.. s n sym)))
                                 s)
        :custom_areas {:right (fn []
                                (local result {})
                                (local seve vim.diagnostic.severity)
                                (local error
                                       (length (vim.diagnostic.get 0
                                                                   {:severity seve.ERROR})))
                                (local warning
                                       (length (vim.diagnostic.get 0
                                                                   {:severity seve.WARN})))
                                (local info
                                       (length (vim.diagnostic.get 0
                                                                   {:severity seve.INFO})))
                                (local hint
                                       (length (vim.diagnostic.get 0
                                                                   {:severity seve.HINT})))
                                (when (not= error 0)
                                  (table.insert result
                                                {:text (.. "  " error)
                                                 :guifg colors.red}))
                                (when (not= warning 0)
                                  (table.insert result
                                                {:text (.. "  " warning)
                                                 :guifg colors.yellow}))
                                (when (not= hint 0)
                                  (table.insert result
                                                {:text (.. "  " hint)
                                                 :guifg colors.blue}))
                                (when (not= info 0)
                                  (table.insert result
                                                {:text (.. "  " info)
                                                 :guifg colors.text}))
                                result)}})
