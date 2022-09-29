(local reg (. (require :which-key) :register))

(reg {:name :+Find
      :f ["<Cmd>Telescope find_files find_command=rg,--files<CR>" :files]
      :e ["<Cmd>Telescope file_browser<CR>" "file explorer"]
      :b ["<Cmd>Telescope buffers<CR>" :buffers]
      :c {:name :+Commands
          :c ["<Cmd>Telescope commands<CR>" :commands]
          :h ["<Cmd>Telescope command_history<CR>" :history]}
      :g {:name :+Git
          :g ["<Cmd>Telescope git_commits<CR>" :commits]
          :c ["<Cmd>Telescope git_bcommits<CR>" :bcommits]
          :b ["<Cmd>Telescope git_branches<CR>" :branches]
          :s ["<Cmd>Telescope git_status<CR>" :status]}
      :r ["<Cmd>Telescope live_grep<CR>" "Live grep"]}
     {:prefix :<leader>f})
