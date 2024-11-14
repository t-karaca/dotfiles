return {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
    },
    keys = {
        {
            "<leader>dv",
            "<cmd>DiffviewOpen<CR>",
            desc = "Open diffview",
        },
        -- {
        --     "<leader>df",
        --     "<cmd>DiffviewFileHistory<CR>",
        --     desc = "Open diffview for history",
        -- },
        {
            "<leader>df",
            "<cmd>DiffviewFileHistory %<CR>",
            desc = "History for current file",
        },
        {
            "<leader>dc",
            "<cmd>DiffviewClose<CR>",
            desc = "Close diffview",
        },
    },
    config = function()
        local diffview = require("diffview")

        diffview.setup({
            hooks = {
                diff_buf_win_enter = function(bufnr)
                    -- vim.opt_local.foldlevel = 1
                end,
            },
        })
    end,
}
