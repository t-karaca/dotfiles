return {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
        -- add any options here
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        -- "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({
            lsp = {
                progress = {
                    enabled = false,
                },
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            cmdline = {
                enabled = false,
                view = "cmdline",
            },
            messages = {
                enabled = false,
            },
            notify = {
                enabled = false,
            },
            popupmenu = {
                popupmenu = false,
                -- enabled = true,
                -- backend = "cmp",
            },
            -- you can enable a preset for easier configuration
            presets = {
                -- bottom_search = true, -- use a classic bottom cmdline for search
                -- command_palette = true, -- position the cmdline and popupmenu together
                -- long_message_to_split = true, -- long messages will be sent to a split
                -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
                -- lsp_doc_border = true, -- add a border to hover docs and signature help
            },
            views = {
                ---@type NoiceViewOptions
                cmdline_popup = {
                    position = {
                        row = "90%",
                        col = "50%",
                    },
                },
                ---@type NoiceViewOptions
                hover = {
                    position = { row = 2, col = 0 },
                    border = {
                        padding = { 1, 2 },
                    },
                },
                signature = {
                    position = { row = 2, col = 0 },
                    border = {
                        padding = { 1, 2 },
                    },
                },
            },
        })

        vim.keymap.set("n", "<C-u>", function()
            if not require("noice.lsp").scroll(-4) then
                return "<C-u>zz"
            end
        end, { silent = true, expr = true })

        vim.keymap.set("n", "<C-d>", function()
            if not require("noice.lsp").scroll(4) then
                return "<C-d>zz"
            end
        end, { silent = true, expr = true })
    end,
}
