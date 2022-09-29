(local reg (. (require :which-key) :register))

(reg {:<A-h> [(. (require :smart-splits) :resize_left) "split resize left"]
      :<A-j> [(. (require :smart-splits) :resize_down) "Split Resize Down"]
      :<A-l> [(. (require :smart-splits) :resize_right) "Split Resize Right"]
      :<A-k> [(. (require :smart-splits) :resize_up) "Split Resize Up"]
      :<C-h> [(. (require :smart-splits) :move_cursor_left) "split move left"]
      :<C-j> [(. (require :smart-splits) :move_cursor_down) "Split Move Down"]
      :<C-l> [(. (require :smart-splits) :move_cursor_right)
              "Split Move Right"]
      :<C-k> [(. (require :smart-splits) :move_cursor_up) "Split Move Up"]
      :<C-S><j> [:<Cmd>vsplit<CR> "New Vsplit"]
      :<C-S><l> [:<Cmd>split<CR> "New Split"]})
