return {
    "rachartier/tiny-code-action.nvim",
    enabled = false,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = function()
        local action = require("tiny-code-action")
        action.setup({
            backend = "delta",
            backend_opts = {
                delta = {
                    args = { "--line-numbers" },
                },
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>ca", action.code_action, { noremap = true, silent = true })
    end,
}
