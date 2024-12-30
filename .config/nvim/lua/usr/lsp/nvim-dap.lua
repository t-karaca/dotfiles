return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        event = { "VeryLazy" },
        config = function()
            vim.fn.sign_define("DapBreakpoint", {
                text = "",
                texthl = "DapBreakpoint",
                linehl = "",
                numhl = "",
            })

            vim.fn.sign_define("DapBreakpointCondition", {
                text = "●",
                texthl = "DapBreakpointCondition",
                linehl = "",
                numhl = "",
            })

            vim.fn.sign_define("DapLogPoint", {
                text = "◆",
                texthl = "DapLogPoint",
                linehl = "",
                numhl = "",
            })

            local dap = require("dap")

            vim.keymap.set("n", "<F6>", function()
                dap.continue({ new = false })
            end, { desc = "Continue execution" })
            vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Step into" })
            vim.keymap.set("n", "<F8>", dap.step_over, { desc = "Step over" })
            vim.keymap.set("n", "<F9>", dap.step_out, { desc = "Step out" })
            vim.keymap.set("n", "<F10>", dap.step_back, { desc = "Step back" })

            vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
            vim.keymap.set("n", "<leader>bc", dap.clear_breakpoints, { desc = "Clear breakpoints" })
            vim.keymap.set("n", "<leader>bl", function()
                dap.list_breakpoints()
                require("telescope.builtin").quickfix()
            end, { desc = "List breakpoints" })

            dap.configurations.java = {
                {
                    type = "java",
                    name = "Remote Debug",
                    request = "attach",
                    hostName = "127.0.0.1",
                    port = 5005,
                },
            }

            require("dap.ext.vscode").load_launchjs(".vscode/launch.json")
            require("dap.ext.vscode").load_launchjs(".vscode/launch-private.json")

            vim.keymap.set("n", "<leader>rp", dap.continue, { desc = "Pick debug configuration" })
            vim.keymap.set("n", "<leader>rl", dap.run_last, { desc = "Run last debug session" })
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

            vim.api.nvim_create_autocmd("TabClosed", {
                callback = function(args)
                    if vim.g.debug_tab_nr and "" .. vim.g.debug_tab_nr == args.file then
                        vim.g.debug_tab_nr = nil
                    end
                end,
            })

            local function open_debug_tab()
                if not vim.g.debug_tab_nr or not pcall(vim.api.nvim_set_current_tabpage, vim.g.debug_tab_nr) then
                    if vim.api.nvim_buf_get_name(0) == "" then
                        vim.cmd("tabnew")
                    else
                        vim.cmd("tabnew %")
                    end

                    vim.g.debug_tab_nr = vim.api.nvim_get_current_tabpage()
                    dapui.open({ reset = true })
                end
            end

            local function close_debug_tab()
                if vim.api.nvim_get_current_tabpage() == vim.g.debug_tab_nr then
                    vim.cmd("tabclose")
                    vim.g.debug_tab_nr = nil
                    return true
                end

                return false
            end

            local function toggle_debug_tab()
                if not close_debug_tab() then
                    open_debug_tab()
                end
            end

            dap.listeners.before.attach.dapui_config = open_debug_tab
            dap.listeners.before.launch.dapui_config = open_debug_tab

            vim.keymap.set("n", "<F1>", toggle_debug_tab, { desc = "Toggle debug ui" })

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
                                size = 0.75,
                            },
                            {
                                id = "stacks",
                                size = 0.25,
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
                        size = 60,
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
        enabled = true,
        event = { "VeryLazy" },
        config = function()
            require("nvim-dap-virtual-text").setup({})
        end,
    },
    {
        "julianolf/nvim-dap-lldb",
        dependencies = { "mfussenegger/nvim-dap" },
        lazy = true,
        ft = { "c", "cpp", "rust", "zig" },
        config = function()
            require("dap-lldb").setup({})
        end,
    },
}
