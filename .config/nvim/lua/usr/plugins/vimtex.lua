return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = "zathura_simple"
        vim.cmd("syntax enable")
    end,
}
