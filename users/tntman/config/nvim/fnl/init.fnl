(require :user)

;; Make sure packer is all ready to go
(let [compiled? (= (vim.fn.filereadable (.. (vim.fn.stdpath :config)
                                            :/lua/packer_compiled.lua))
                   1)
      load-compiled #(require :packer_compiled)]
  (if compiled?
      (load-compiled)
      (. (require :packer) :sync)))

;; load notifs early
(local (_ err) (pcall require :notify))
(when (not err)
  (require :plugins.notify))
 
;; load the dashboard early
(local (_ err2) (pcall require :dashboard))
(when (not err2)
  (require :plugins.dashboard))

(require :plugins)
(require :keybinds)
