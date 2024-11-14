return {
    "akinsho/toggleterm.nvim",
    version = "*",
    enabled = false,
    config = function()
        local toggleterm = require("toggleterm")
        local colors = require("catppuccin.palettes").get_palette("mocha")

        toggleterm.setup({
            direction = "float",
            highlights = {
                NormalFloat = {
                    guibg = colors.mantle,
                },
                FloatBorder = {
                    guibg = colors.mantle,
                    guifg = colors.mantle,
                },
            },
            float_opts = {
                border = "single",
            },
        })

        local Terminal = require("toggleterm.terminal").Terminal

        function _lazygit_toggle()
            local lazygit = Terminal:new({
                display_name = "lazygit",

                cmd = "lazygit",
                hidden = true,

                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.api.nvim_buf_set_keymap(
                        term.bufnr,
                        "n",
                        "q",
                        "<cmd>close<CR>",
                        { noremap = true, silent = true }
                    )

                    vim.b[term.bufnr].display_name = "lazygit"
                end,

                on_close = function(term)
                    vim.cmd("startinsert!")
                end,

                highlights = {
                    NormalFloat = {
                        guibg = "none",
                    },
                },
                float_opts = {
                    border = "none",
                },
            })

            lazygit:open()
        end

        vim.keymap.set(
            "n",
            "<leader>g",
            "<cmd>lua _lazygit_toggle()<CR>",
            { desc = "Open lazygit", noremap = true, silent = true }
        )

        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set("t", "<C-x>", [[<C-\><C-n>]], opts)
        end

        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
}
