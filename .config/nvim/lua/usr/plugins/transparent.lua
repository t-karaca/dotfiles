return {
    "xiyaowong/transparent.nvim",
    config = function()
        local transparent = require("transparent")

        transparent.setup({
            extra_groups = {
                "NvimTreeNormal",
                "TroubleNormal",
                "TroubleNormalNC",
            },
            exclude_groups = {
                "CursorLine",
            },
        })

        transparent.clear_prefix("BufferLine")
    end,
}
