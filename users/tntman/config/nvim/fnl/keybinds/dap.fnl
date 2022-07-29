(local reg (. (require :which-key) :register))

(local dap (require :dap))

(fn isempty [s]
  (or (= s nil) (= s "")))

(reg {:name :+Debugging
      :c [dap.continue "Start/Continue Debugging"]
      :b [dap.toggle_breakpoint "Toggle Breakpoint"]
      :B [#(vim.ui.input {:prompt "Breakpoint condition: "}
                         (fn [input]
                           (when (not (isempty input))
                             (dap.set_breakpoint input))))
          "Set Breakpoint Condition"]
      :p [#(vim.ui.input {:prompt "Log point message: "}
                         (fn [input]
                           (when (not (isempty input))
                             (dap.set_breakpoint nil nil input))))
          "Set Log Point"]
      :e [dap.repl.open "Evaluate Expression"]
      :l [dap.run_last "Evaluate Last Expression"]
      :o [(. (require :dapui) :toggle) "Toggle DAP UI"]
      :s {:name :+Step
          :o [dap.step_over "Step Over"]
          :i [dap.step_into "Step Into"]}} {:prefix :<leader>d})
