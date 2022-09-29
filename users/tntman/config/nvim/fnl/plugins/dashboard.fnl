(local db (require :dashboard))
(fn custom-header []
  [""
   ""
   ""
   " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗"
   " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║"
   " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║"
   " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║"
   " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║"
   " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝"
   ""
   ""])

(set db.custom_header custom-header)
(set db.custom_center [{:icon "  "
                        :desc "Recently laset session                  "
                        :shortcut "SPC s l"
                        :action :SessionLoad}
                       {:icon "  "
                        :desc "Find  File                              "
                        :action "Telescope find_files find_command=rg,--hidden,--files"
                        :shortcut "SPC f f"}
                       {:icon "  "
                        :desc "File Browser                            "
                        :action "Telescope file_browser"
                        :shortcut "SPC f e"}])
