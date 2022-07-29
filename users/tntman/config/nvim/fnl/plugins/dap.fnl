(local dap (require :dap))
(local sd vim.fn.sign_define)

(sd :DapBreakpoint {:text "" :texthl "" :linehl "" :numhl ""})

(sd :DapBreakpointCondition {:text "" :texthl "" :linehl "" :numhl ""})

(sd :DapBreakpointRejected {:text "" :texthl "" :linehl "" :numhl ""})

(sd :DapLogPoint {:text "" :texthl "" :linehl "" :numhl ""})

((. (require :nvim-dap-virtual-text) :setup) {:enabled true
                                              :enabled_commands true
                                              :highlight_changed_variables true
                                              :show_stop_reason true
                                              :commented true})

((. (require :dapui) :setup))

;; adapters
(set dap.adapters.lldb {:type :executable :command :lldb-vscode :name :lldb})

(set dap.adapters.node2
     {:type :executable
      :command :node
      :args {1 :/mnt/BulkStorage/projects/microsoft/vscode-node-debug2/out/src/nodeDebug.js}})

(set dap.configurations.javascript
     [{:name :Launch
       :type :node2
       :request :launch
       :program "${file}"
       :cwd (vim.fn.getcwd)
       :sourceMaps true
       :protocol :inspector
       :console :integratedTerminal}
      {:name "Attach to process"
       :type :node2
       :request :attach
       :processId (. (require :dap.utils) :pick_process)}])

(set dap.adapters.coreclr
     {:type :executable :command :netcoredbg :args [:--interpreter=vscode]})
