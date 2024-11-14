return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        local catppuccin = require("catppuccin")
        local colors = require("catppuccin.palettes").get_palette("mocha")

        catppuccin.setup({
            flavour = "mocha",
            no_italic = true,
            integrations = {
                lsp_trouble = true,
                blink_cmp = true,
                telescope = {
                    enabled = true,
                    style = "nvchad",
                },
                -- for transparent background, looks better without integration
                nvimtree = false,
                diffview = false,
                harpoon = false,
            },
        })

        vim.cmd("hi Sneak guibg=" .. colors.overlay0 .. " guifg=white gui=bold")
        vim.cmd("hi SneakLabel guibg=" .. colors.overlay0 .. " guifg=white gui=bold")
        vim.cmd("hi link SneakLabelMask None")

        vim.cmd.colorscheme("catppuccin")

        vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = colors.mantle })
        vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = colors.mantle, fg = colors.mantle })
    end,
}
