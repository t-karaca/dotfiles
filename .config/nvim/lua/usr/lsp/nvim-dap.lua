return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        event = { "VeryLazy" },
        config = function()
            vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })

            local dap = require("dap")

            vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
            vim.keymap.set("n", "<leader>rl", dap.run_last, { desc = "Run last debug session" })

            vim.keymap.set("n", "<F6>", function()
                dap.continue({ new = false })
            end, { desc = "Continue execution" })
            vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Step into" })
            vim.keymap.set("n", "<F8>", dap.step_over, { desc = "Step over" })
            vim.keymap.set("n", "<F9>", dap.step_out, { desc = "Step out" })
            vim.keymap.set("n", "<F10>", dap.step_back, { desc = "Step back" })

            dap.configurations.java = {
                {
                    type = "java",
                    name = "Remote Debug",
                    request = "attach",
                    hostName = "127.0.0.1",
                    port = 5005,
                },
            }

            require("dap.ext.vscode").load_launchjs()
            require("dap.ext.vscode").load_launchjs(".vscode/launch-private.json")

            local function pick_config()
                local filetype = vim.bo.filetype
                local configs = dap.configurations[filetype]

                if configs ~= nil then
                    vim.ui.select(configs, {
                        format_item = function(item)
                            return item.name
                        end,
                    }, function(item)
                        if item ~= nil then
                            dap.run(item)
                        end
                    end)
                end
            end

            vim.keymap.set("n", "<leader>rp", pick_config, { desc = "Pick debug configuration" })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        event = { "VeryLazy" },
        dependencies = {
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            -- dap.listeners.before.event_terminated.dapui_config = function()
            -- 	dapui.close()
            -- end
            -- dap.listeners.before.event_exited.dapui_config = function()
            -- 	dapui.close()
            -- end

            vim.keymap.set("n", "<F1>", dapui.toggle, { desc = "Toggle debug ui" })

            dapui.setup({
                controls = {
                    element = "console",
                    enabled = true,
                    icons = {
                        disconnect = "",
                        pause = "",
                        play = "",
                        run_last = "",
                        step_back = "",
                        step_into = "",
                        step_out = "",
                        step_over = "",
                        terminate = "",
                    },
                },
                layouts = {
                    {
                        elements = {
                            {
                                id = "console",
                                size = 1,
                            },
                        },
                        position = "bottom",
                        size = 18,
                    },
                    {
                        elements = {
                            {
                                id = "scopes",
                                size = 0.5,
                            },
                            {
                                id = "repl",
                                size = 0.5,
                            },
                        },
                        position = "right",
                        size = 40,
                    },
                },
                mappings = {
                    edit = "e",
                    expand = { "<Tab>", "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    repl = "r",
                    toggle = "t",
                },
            })
        end,
    },
    {
        "leoluz/nvim-dap-go",
        lazy = true,
        ft = { "go" },
        config = function()
            local dapgo = require("dap-go")

            vim.keymap.set("n", "<leader>rg", dapgo.debug_test, { desc = "Run go test under cursor" })

            dapgo.setup({})
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
        enabled = false,
        event = { "VeryLazy" },
        config = function()
            require("nvim-dap-virtual-text").setup({})
        end,
    },
}
