;; Make sure packer is all ready to go
(let [compiled? (= (vim.fn.filereadable (.. (vim.fn.stdpath :config) "/lua/packer_compiled.lua")) 1)
      load-compiled #(require :packer_compiled)]
 (if compiled?
     (load-compiled)
     (. (require :packer) :sync)))

((. (require :fnl.user) :config))

(local (_ err) (pcall require :notify))
(when (not err)
  (require :lua.plugins.notify))

(local (_ err2) (pcall require :dashboard))
(when (not err2)
  (require :lua.plugins.dashboard))

(require :lua.plugins)
(require :lua.keybindings)
