return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local lualine = require("lualine")
        -- local theme = require("lualine.themes.auto")
        local theme = require("lualine.themes.catppuccin-mocha")

        -- make background transparent
        theme.inactive.c.bg = nil
        theme.normal.c.bg = nil

        lualine.setup({
            options = {
                globalstatus = true,
                theme = theme,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            extensions = {
                "nvim-tree",
                {
                    filetypes = { "toggleterm" },
                    sections = {
                        lualine_a = {
                            function()
                                local statusline = vim.b.display_name
                                if statusline == nil then
                                    statusline = "ToggleTerm #" .. vim.b.toggle_number
                                end
                                return statusline
                            end,
                        },
                    },
                },
                "nvim-dap-ui",
                "mason",
                "lazy",
                "quickfix",
            },
        })
    end,
}
