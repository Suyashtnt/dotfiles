(local telescope (require :telescope))
(local setup telescope.setup)

(fn load_exts [exts]
  (each [_ ext (ipairs exts)]
    (telescope.load_extension ext)))

(setup {:extensions {:fzf {:fuzzy true
                           :override_generic_sorter true
                           :override_file_sorter true
                           :case_mode :smart_case}}})

(load_exts [:file_browser :notify :media_files :ghq :zoxide])
