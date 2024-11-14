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
        })

        transparent.clear_prefix("BufferLine")
    end,
}
