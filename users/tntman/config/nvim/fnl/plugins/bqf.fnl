(fn _G.qftf [info]
  (var items nil)
  (local ret {})
  (if (= info.quickfix 1) (set items
                               (. (vim.fn.getqflist {:id info.id :items 0})
                                  :items))
      (set items (. (vim.fn.getloclist info.winid {:id info.id :items 0})
                    :items)))
  (local limit 31)
  (local (fname-fmt1 fname-fmt2)
         (values (.. "%-" limit :s) (.. "…%." (- limit 1) :s)))
  (local valid-fmt "%s │%5d:%-3d│%s %s")
  (for [i info.start_idx info.end_idx 1]
    (local e (. items i))
    (var fname "")
    (var str nil)
    (if (= e.valid 1)
        (do
          (when (> e.bufnr 0)
            (set fname (vim.fn.bufname e.bufnr))
            (if (= fname "") (set fname "[No Name]")
                (set fname (fname:gsub (.. "^" vim.env.HOME) "~")))
            (if (<= (length fname) limit) (set fname (fname-fmt1:format fname))
                (set fname (fname-fmt2:format (fname:sub (- 1 limit))))))
          (local lnum (or (and (> e.lnum 99999) (- 1)) e.lnum))
          (local col (or (and (> e.col 999) (- 1)) e.col))
          (local qtype
                 (or (and (= e.type "") "")
                     (.. " " (: (e.type:sub 1 1) :upper))))
          (set str (valid-fmt:format fname lnum col qtype e.text)))
        (set str e.text))
    (table.insert ret str))
  ret)

(set vim.o.qftf "{info -> v:lua._G.qftf(info)}")
(local setup (. (require :bqf) :setup))
(setup {:filter {:fzf {:extra_opts [:--bind
                                    "ctrl-o:toggle-all"
                                    :--delimiter
                                    "│"]}}
        :auto_resize_height true
        :func_map {:tab :st
                   :split :sv
                   :vsplit :sg
                   :stoggleup :K
                   :stoggledown :J
                   :stogglevm :<Space>
                   :ptoggleitem :p
                   :ptoggleauto :P
                   :ptogglemode :zp
                   :pscrollup :<C-b>
                   :pscrolldown :<C-f>
                   :prevfile :gk
                   :nextfile :gj
                   :prevhist :<S-Tab>
                   :nexthist :<Tab>}
        :preview {:auto_preview true
                  :should_preview_cb (fn [bufnr]
                                       (var ret true)
                                       (local filename
                                              (vim.api.nvim_buf_get_name bufnr))
                                       (local fsize (vim.fn.getfsize filename))
                                       (when (> fsize (* 100 1024))
                                         (set ret false))
                                       ret)}})
