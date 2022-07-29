(local reg (. (require :which-key) :register))

(reg {:e ["<Cmd>Neotree filesystem toggle<CR>" "Toggle sidebar / file tree"]
      :o [:<Cmd>Vista<CR> "Toggle vista / code outliner"]
      :z [#((. (require :zen-mode) :toggle) {:window {:width 0.8}})
          "Enter the code zone (Zen mode)"]} {:prefix :<leader>})
