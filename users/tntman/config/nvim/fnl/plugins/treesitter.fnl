(local setup (. (require :nvim-treesitter.configs) :setup))

(setup {:highlight {:enable true}
        :indent {:enable true}
        :autotag {:enable true}
        :rainbow {:enable true :extended_mode true}})
