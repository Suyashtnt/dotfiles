(local reg (. (require :which-key) :register))

(reg {:name :Comments
      :c "Toggle comment linewise"
      :o "comment and insert"
      :O "comment and insert back"
      :A "comment and insert EOL"} {:prefix :gc})

(reg {:name :Comments :c "Toggle comment blockwise"} {:prefix :gb})
