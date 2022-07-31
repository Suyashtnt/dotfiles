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

(set _G.playerctl (bling.signal.playerctl.lib))
;; TODO: remove this
(set _G.dpi beautiful.xresources.apply_dpi)

(require :awful.autofocus)
(require :awful.hotkeys_popup.keys)

(set _G.terminal :alacritty)
(set _G.editor (or (os.getenv :EDITOR) :nvim))
(set _G.modkey :Mod4)

(load-mods! :notifs :layouts :tags :taglist :tasklist :layoutbox :wibar
            :rightbar :keybinds :client)

;; TODO add night wallpaper
(bling.module.wallpaper.setup {:set_function bling.module.wallpaper.setters.simple_schedule
                               :wallpaper {"07:00:00" (.. (os.getenv :HOME)
                                                          :/dotfiles/users/tntman/config/awesome/wallpapers/day.png)}
                               :position :maximized})

(ruled.client.connect_signal "request::rules"
                             #(let [tags (require :modules.tags)]
                                (ruled.client.append_rule {:id :global
                                                           :rule {}
                                                           :properties {:focus awful.client.focus.filter
                                                                        :raise true
                                                                        :screen awful.screen.preferred
                                                                        :placement (+ awful.placement.no_overlap
                                                                                      awful.placement.no_offscreen)}})
                                (ruled.client.append_rule {:id :floating
                                                           :rule_any {:instance [:copyq
                                                                                 :pinentry]
                                                                      :role [:pop-up]}
                                                           :properties {:floating true}})))

