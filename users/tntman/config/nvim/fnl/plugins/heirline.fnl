(local conditions (require :heirline.conditions))
(local utils (require :heirline.utils))

(local Vi-mode {:init (fn [self]
                        (set self.mode (vim.fn.mode 1))
                        (when (not self.once)
                          (vim.api.nvim_create_autocmd :ModeChanged
                                                       {:command :redrawstatus})
                          (set self.once true)))
                :static {:mode_names {:n :N
                                      :no :N?
                                      :nov :N?
                                      :noV :N?
                                      "no\022" :N?
                                      :niI :Ni
                                      :niR :Nr
                                      :niV :Nv
                                      :nt :Nt
                                      :v :V
                                      :vs :Vs
                                      :V :V_
                                      :Vs :Vs
                                      "\022" :^V
                                      "\022s" :^V
                                      :s :S
                                      :S :S_
                                      "\019" :^S
                                      :i :I
                                      :ic :Ic
                                      :ix :Ix
                                      :R :R
                                      :Rc :Rc
                                      :Rx :Rx
                                      :Rv :Rv
                                      :Rvc :Rv
                                      :Rvx :Rv
                                      :c :C
                                      :cv :Ex
                                      :r "..."
                                      :rm :M
                                      :r? "?"
                                      :! "!"
                                      :t :T}
                         :mode_colors {:n :red
                                       :i :green
                                       :v :cyan
                                       :V :cyan
                                       "\022" :cyan
                                       :c :orange
                                       :s :purple
                                       :S :purple
                                       "\019" :purple
                                       :R :orange
                                       :r :orange
                                       :! :red
                                       :t :red}}
                :provider (fn [self]
                            (.. " %2(" (. self.mode_names self.mode) "%)"))
                :hl (fn [self]
                      (local mode (self.mode:sub 1 1))
                      {:fg (. self.mode_colors mode) :bold true})
                :update :ModeChanged})

(local File-name-blck
       {:init (fn [self]
                (set self.filename (vim.api.nvim_buf_get_name 0)))})

(local File-icon {:init (fn [self]
                          (local filename self.filename)
                          (local extension (vim.fn.fnamemodify filename ":e"))
                          (set-forcibly! (self.icon self.icon_color)
                                         ((. (require :nvim-web-devicons)
                                             :get_icon_color) filename
                                                                                                                                        extension
                                                                                                                                        {:default true})))
                  :provider (fn [self]
                              (and self.icon (.. self.icon " ")))
                  :hl (fn [self]
                        {:fg self.icon_color})})

(local File-name
       {:provider (fn [self]
                    (var filename (vim.fn.fnamemodify self.filename ":."))
                    (when (= filename "")
                      (lua "return \"[No Name]\""))
                    (when (not (conditions.width_percent_below (length filename)
                                                               0.25))
                      (set filename (vim.fn.pathshorten filename)))
                    filename)
        :hl {:fg (. (utils.get_highlight :Directory) :fg)}})

(local File-flags {1 {:provider (fn []
                                  (when vim.bo.modified
                                    "[+]"))
                      :hl {:fg :green}}
                   2 {:provider (fn []
                                  (when (or (not vim.bo.modifiable)
                                            vim.bo.readonly)
                                    ""))
                      :hl {:fg :orange}}})

(local File-name-modifer
       {:hl (fn []
              (when vim.bo.modified
                {:fg :cyan :bold true :force true}))})

(local File-name-block
       (utils.insert File-name-blck File-icon
                     (utils.insert File-name-modifer File-name)
                     (unpack File-flags) {:provider "%<"}))

(local File-type
       {:provider (fn []
                    (string.upper vim.bo.filetype))
        :hl {:fg (. (utils.get_highlight :Type) :fg) :bold true}})

(local Ruler {:provider "%7(%l/%3L%):%2c %P"})

(local Scroll-bar {:static {:sbar {1 "▁"
                                   2 "▂"
                                   3 "▃"
                                   4 "▄"
                                   5 "▅"
                                   6 "▆"
                                   7 "▇"
                                   8 "█"}}
                   :provider (fn [self]
                               (local curr-line
                                      (. (vim.api.nvim_win_get_cursor 0) 1))
                               (local lines (vim.api.nvim_buf_line_count 0))
                               (local i
                                      (+ (math.floor (* (/ (- curr-line 1)
                                                           lines)
                                                        (length self.sbar)))
                                         1))
                               (string.rep (. self.sbar i) 2))
                   :hl {:fg :blue :bg :bright_bg}})

(local LSPActive {:condition conditions.lsp_attached
                  :update {1 :LspAttach 2 :LspDetach}
                  :provider (fn []
                              (local names {})
                              (each [_ server (pairs (vim.lsp.buf_get_clients 0))]
                                (table.insert names server.name))
                              (.. " [" (table.concat names " ") "]"))
                  :hl {:fg :green :bold true}})

(local Diagnostics {:condition conditions.has_diagnostics
                    :static {:error_icon (. (. (vim.fn.sign_getdefined :DiagnosticSignError)
                                               1)
                                            :text)
                             :warn_icon (. (. (vim.fn.sign_getdefined :DiagnosticSignWarn)
                                              1)
                                           :text)
                             :info_icon (. (. (vim.fn.sign_getdefined :DiagnosticSignInfo)
                                              1)
                                           :text)
                             :hint_icon (. (. (vim.fn.sign_getdefined :DiagnosticSignHint)
                                              1)
                                           :text)}
                    :init (fn [self]
                            (set self.errors
                                 (length (vim.diagnostic.get 0
                                                             {:severity vim.diagnostic.severity.ERROR})))
                            (set self.warnings
                                 (length (vim.diagnostic.get 0
                                                             {:severity vim.diagnostic.severity.WARN})))
                            (set self.hints
                                 (length (vim.diagnostic.get 0
                                                             {:severity vim.diagnostic.severity.HINT})))
                            (set self.info
                                 (length (vim.diagnostic.get 0
                                                             {:severity vim.diagnostic.severity.INFO}))))
                    :update {1 :DiagnosticChanged 2 :BufEnter}
                    1 {:provider "!["}
                    2 {:provider (fn [self]
                                   (and (> self.errors 0)
                                        (.. self.error_icon self.errors " ")))
                       :hl {:fg :diag_error}}
                    3 {:provider (fn [self]
                                   (and (> self.warnings 0)
                                        (.. self.warn_icon self.warnings " ")))
                       :hl {:fg :diag_warn}}
                    4 {:provider (fn [self]
                                   (and (> self.info 0)
                                        (.. self.info_icon self.info " ")))
                       :hl {:fg :diag_info}}
                    5 {:provider (fn [self]
                                   (and (> self.hints 0)
                                        (.. self.hint_icon self.hints)))
                       :hl {:fg :diag_hint}}
                    6 {:provider "]"}})

(local Gps {:condition (. (require :nvim-navic) :is_available)
            :static {:type_map {:Method :blue
                                :Field :purple
                                :Function :blue
                                :Property :purple
                                :Variable :purple}}
            :init (fn [self]
                    (local data (or ((. (require :nvim-navic) :get_data)) {}))
                    (local children {})
                    (each [_ value (ipairs data)]
                      (local child
                             {1 {:provider " > " :hl {:fg :blue}}
                              2 {:provider value.icon
                                 :hl {:fg (. self.type_map value.type)}}
                              3 {:provider value.name :hl {:fg "#f5e0dc"}}})
                      (table.insert children child))
                    (tset self 1 (self:new children 1)))
            :hl {:fg :gray}})

(local Align {:provider "%="})
(local Space {:provider " "})

(fn setup-colors []
  {:bright_bg (. (utils.get_highlight :Folded) :bg)
   :red (. (utils.get_highlight :DiagnosticError) :fg)
   :dark_red (. (utils.get_highlight :DiffDelete) :bg)
   :green (. (utils.get_highlight :String) :fg)
   :blue (. (utils.get_highlight :Function) :fg)
   :gray (. (utils.get_highlight :NonText) :fg)
   :orange (. (utils.get_highlight :Constant) :fg)
   :purple (. (utils.get_highlight :Statement) :fg)
   :cyan (. (utils.get_highlight :Special) :fg)
   :diag_warn (. (utils.get_highlight :DiagnosticWarn) :fg)
   :diag_error (. (utils.get_highlight :DiagnosticError) :fg)
   :diag_hint (. (utils.get_highlight :DiagnosticHint) :fg)
   :diag_info (. (utils.get_highlight :DiagnosticInfo) :fg)})

(local Vi-mode-but-cool (utils.surround {1 "" 2 ""} :bright_bg
                                        {1 Vi-mode}))

(local statusline {1 Vi-mode-but-cool
                   2 Space
                   3 File-name-block
                   4 Space
                   5 Diagnostics
                   6 Align
                   7 LSPActive
                   8 Space
                   9 File-type
                   10 Space
                   11 Ruler
                   12 Space
                   13 Scroll-bar
                   :hl {:bg "#181825"}})

(local winbar {:init utils.pick_child_on_condition
               1 {:condition (fn []
                               (conditions.buffer_matches {:buftype [:nofile
                                                                     :prompt
                                                                     :help
                                                                     :quickfix]
                                                           :filetype [:^git.*
                                                                      :fugitive]}))
                  :init (fn []
                          (set vim.opt_local.winbar nil))}
               2 {:condition (fn []
                               (not (conditions.is_active)))
                  1 (utils.surround {1 "" 2 ""} "#181825"
                                    {:hl {:fg :gray :force true}
                                     1 {1 File-name-block 2 Gps}})}
               3 {1 (utils.surround {1 "" 2 ""} "#181825"
                                    {1 File-name-block 2 Gps})}})

((. (require :heirline) :load_colors) (setup-colors))
(vim.api.nvim_create_augroup :Heirline {:clear true})
(vim.api.nvim_create_autocmd :ColorScheme
                             {:callback (fn []
                                          ((. (require :heirline)
                                              :reset_highlights))
                                          ((. (require :heirline) :load_colors) (setup-colors)))
                              :group :Heirline})

((. (require :heirline) :setup) statusline)
