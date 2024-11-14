return {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        local nvimsurround = require("nvim-surround")

        nvimsurround.setup({
            keymaps = {
                normal = "gs",
                normal_cur = "gss",
                normal_line = "gS",
                normal_cur_line = "gS",
            },
        })
    end,
}
