(macro load-binds! [...]
  `(local ,(icollect [_ mod (ipairs [...])]
             (sym mod))
          ,(icollect [_ mod (ipairs [...])]
             `(require ,(.. :modules.keybinds. mod)))))


(load-binds! :awesome :spotify :screenshot :apps :tags :focus :layout)
