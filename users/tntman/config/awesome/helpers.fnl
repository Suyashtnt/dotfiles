(local wibox (require :wibox))
(local gears (require :gears))
(local beautiful (require :beautiful))
(local helpers {})

(fn file-exists [file]
  (let [f (io.open file :rb)]
    (when f
      (f:close))
    (not= f nil)))

(set helpers.read_file #(do
                          (when (not (file-exists $1))
                            (let [erlret {}]
                              (lua "return erlret")))
                          (local lines {})
                          (each [line (io.lines $1)]
                            (tset lines (+ (length lines) 1) line))
                          lines))

(set helpers.merge (fn [t1 t2] (each [k v (pairs t2)]
                       (tset t1 k v)) t1))

(set helpers.colorize_text #(.. "<span foreground='" $2 "'>" $1 :</span>))

(set helpers.create_emoji
     #(.. "<span foreground='" $2 "' font='" beautiful.icon_font "'>" $1
          :</span>))

(set helpers.rrect
     #(fn [cr width height]
        (gears.shape.rounded_rect cr width height $1)))

(set helpers.prrect
     (fn [radius tl tr br bl]
       (fn [cr width height]
         (gears.shape.partially_rounded_rect cr width height tl tr br bl radius))))

(fn helpers.vertical_pad [height]
  (wibox.widget {:forced_height height :layout wibox.layout.fixed.vertical}))

(fn helpers.horizontal_pad [width]
  (wibox.widget {:forced_width width :layout wibox.layout.fixed.horizontal}))

helpers
