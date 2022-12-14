(local bling (require :bling))
(local rubato (require :rubato))

(local anim-y (rubato.timed {:pos 1090
                             :rate 60
                             :easing rubato.quadratic
                             :intro 0.1
                             :duration 0.3
                             :awestore_compat true}))

(local anim-x (rubato.timed {:pos (- 970)
                             :rate 60
                             :easing rubato.quadratic
                             :intro 0.1
                             :duration 0.3
                             :awestore_compat true}))

(bling.module.scratchpad {:command "alacritty --class=spad -t spad"
                          :rule {:instance :spad}
                          :sticky true
                          :autoclose true
                          :floating true
                          :geometry {:x 360 :y 90 :height 900 :width 1200}
                          :reapply true
                          :dont_focus_before_close false})
