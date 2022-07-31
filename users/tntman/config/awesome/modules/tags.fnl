(local awful (require :awful))
(local machi (require :layout-machi))

(local tags ["\u{f120}"
             "\u{e007}"
             "\u{f121}"
             "\u{f392}"
             "\u{f1b6}"
             "\u{f025}"
             "\u{f013}"])

(_G.screen.connect_signal "request::desktop_decoration"
                       (fn [s]
                         (each [_ tag (pairs tags)]
                           (awful.tag.add tag
                                          {:layout machi.default_layout
                                           :screen s}))))

tags	
