(local awful (require :awful))
(local beautiful (require :beautiful))
(local helpers (require :helpers))
(local gears (require :gears))
(local awesome (require :awesome))

(local ccs _G.client.connect_signal)

(ccs "request::default_mousebindings"
     #(awful.mouse.append_client_mousebindings [(awful.button {} 1
                                                              #($1:activate {:context :mouse_click}))
                                                (awful.button [_G.modkey] 1
                                                              #($1:activate {:context :mouse_click
                                                                             :action :mouse_move}))
                                                (awful.button [_G.modkey] 3
                                                              #($1:activate {:context :mouse_click
                                                                             :action :mouse_resize}))]))

(ccs :manage (fn [c]
               (when (not= beautiful.border_radius nil)
                 (set c.shape (helpers.rrect beautiful.border_radius)))

               (when (and (and awesome.startup (not c.size_hints.user_position))
                          (not c.size_hints.program_position))
                 (awful.placement.no_offscreen c))

               ;; set placeholder icon if the app has no icon
               (when (= c.icon nil)
                 (local i
                        (gears.surface (beautiful.theme_assets.awesome_icon 256
                                                                            beautiful.blue
                                                                            beautiful.bg_normal)))
                 (set c.icon i._native))))

(ccs "mouse::enter" #($1:activate {:context :mouse_enter :raise false}))
