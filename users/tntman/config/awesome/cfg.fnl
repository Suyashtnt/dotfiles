(pcall require :luarocks.loader)

(macro load-mods! [...]
  `(local ,(icollect [_ mod (ipairs [...])]
             (sym mod))
          ,(icollect [_ mod (ipairs [...])]
             `(require ,(.. :modules. mod)))))

;; Libs
(local gears (require :gears))
(local gfs gears.filesystem)
(local awful (require :awful))
(local helpers (require :helpers))
(local beautiful (require :beautiful))
(local ruled (require :ruled))
(local bling (require :bling))
(local machi (require :layout-machi))

(beautiful.init (.. (gfs.get_configuration_dir) :theme.lua))

;; set cool icon for layout-machi
(tset (require :beautiful) :layout_machi (machi.get_icon))

(global playerctl (bling.signal.playerctl.lib))
;; TODO: remove this
(global dpi beautiful.xresources.apply_dpi)

(require :awful.autofocus)
(require :awful.hotkeys_popup.keys)

(global terminal :alacritty)
(global editor (or (os.getenv :EDITOR) :nvim))
(global editor-cmd (.. terminal " -e " editor))
(global modkey :Mod4)

(load-mods! :notifs :layouts :tags :taglist :tasklist :layoutbox :wibar
            :rightbar :keybinds)

(local scs screen.connect_signal)

;; TODO add night wallpaper
#(bling.module.wallpaper.setup {:set_function bling.module.wallpaper.setters.simple_schedule
                                :schedule_set_function bling.module.wallpaper.setters.random
                                :change_timer 600
                                :wallpaper {"07:00:00" (.. (os.getenv :HOME)
                                                           :/.config/awesome/wallpapers/day)}
                                :position :maximized})

(local ccs client.connect_signal)
(ccs "request::default_mousebindings"
     #(awful.mouse.append_client_mousebindings [(awful.button {} 1
                                                              #($1:activate {:context :mouse_click}))
                                                (awful.button [modkey] 1
                                                              #($1:activate {:context :mouse_click
                                                                             :action :mouse_move}))
                                                (awful.button [modkey] 3
                                                              #($1:activate {:context :mouse_click
                                                                             :action :mouse_resize}))]))

;; TODO: cleanup this awful code
(ccs :manage (fn [c]
               (when (not= beautiful.border_radius nil)
                 (set c.shape (helpers.rrect beautiful.border_radius)))
               (when (and (and awesome.startup (not c.size_hints.user_position))
                          (not c.size_hints.program_position))
                 (awful.placement.no_offscreen c))
               (when (= c.icon nil)
                 (local i
                        (gears.surface (beautiful.theme_assets.awesome_icon 256
                                                                            beautiful.blue
                                                                            beautiful.bg_normal)))
                 (set c.icon i._native))))

(ruled.client.connect_signal "request::rules"
                             (fn []
                               (let [tags (require :modules.tags)]
                                 (ruled.client.append_rule {:id :global
                                                            :rule {}
                                                            :properties {:focus awful.client.focus.filter
                                                                         :raise true
                                                                         :screen awful.screen.preferred
                                                                         :placement (+ awful.placement.no_overlap
                                                                                       awful.placement.no_offscreen)}})
                                 (ruled.client.append_rule {:id :floating
                                                            :rule_any {:instance {1 :copyq
                                                                                  2 :pinentry}
                                                                       :role {1 :pop-up}}
                                                            :properties {:floating true}})
                                 (ruled.client.append_rule {:rule {:class {1 :Firefox}}
                                                            :properties {:screen 1
                                                                         :tag (. tags
                                                                                 2)}})
                                 (ruled.client.append_rule {:rule {:class {1 :Steam}}
                                                            :properties {:screen 1
                                                                         :tag (. tags
                                                                                 5)}})
                                 (ruled.client.append_rule {:rule {:class {1 :Discord}}
                                                            :properties {:screen 1
                                                                         :tag (. tags
                                                                                 4)}})
                                 (ruled.client.append_rule {:rule {:class {1 :neovide}}
                                                            :properties {:screen 1
                                                                         :tag (. tags
                                                                                 3)}})
                                 (ruled.client.append_rule {:rule {:class {1 :Spotify}}
                                                            :properties {:screen 1
                                                                         :tag (. tags
                                                                                 6)}}))))

(ccs "mouse::enter"
     (fn [c]
       (c:activate {:context :mouse_enter :raise false})))
