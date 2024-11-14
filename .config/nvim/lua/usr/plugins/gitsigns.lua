return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup({
            current_line_blame = true,
            current_line_blame_opts = {
                delay = 0,
            },
        })

        vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { noremap = true, desc = "Stage hunk" })
        vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { noremap = true, desc = "Reset hunk" })
        vim.keymap.set("n", "<leader>gU", gitsigns.reset_buffer_index, { noremap = true, desc = "Unstage buffer" })
        vim.keymap.set("v", "<leader>gs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { noremap = true, desc = "Stage hunk" })
        vim.keymap.set("v", "<leader>gr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { noremap = true, desc = "Reset hunk" })
        vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { noremap = true, desc = "Stage buffer" })
        vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { noremap = true, desc = "Reset buffer" })
    end,
}
