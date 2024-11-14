return {
    "j-hui/fidget.nvim",
    config = function()
        require("fidget").setup({
            notification = {
                window = {
                    winblend = 0,
                },
            },
            integration = {
                ["nvim-tree"] = {
                    enable = false,
                },
            },
        })
    end,
}
