(local awful (require :awful))
(local bling (require :bling))
(local machi (require :layout-machi))

(local tcs _G.tag.connect_signal)

(tcs "request::default_layouts"
     #(awful.layout.append_default_layouts [machi.default_layout
                                            bling.layout.mstab]))
