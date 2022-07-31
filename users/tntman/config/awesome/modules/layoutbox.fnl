(local awful (require :awful))
(local scs _G.screen.connect_signal)

(scs "request::desktop_decoration"
     (fn [s]
       (set s.layoutbox
            (awful.widget.layoutbox {:screen s
                                     :buttons [(awful.button {} 1
                                                             #(awful.layout.inc 1))
                                               (awful.button {} 3
                                                             #(awful.layout.inc (- 1)))
                                               (awful.button {} 4
                                                             #(awful.layout.inc (- 1)))
                                               (awful.button {} 5
                                                             #(awful.layout.inc 1))]}))))
