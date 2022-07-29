(local reg (. (require :which-key) :register))

(reg {:e ["<Cmd>Neotree filesystem toggle float<CR>"
          "Toggle sidebar / file tree"]
      :z [#((. (require :zen-mode) :toggle) {:window {:width 0.8}})
          "Enter t h e c o d e z o n e"]} {:prefix :<leader>} :d
     [:<Cmd>bdelete<CR> "Delete current buffer"])
