return {
    "numToStr/Comment.nvim",
    enabled = false,
    config = function()
        local comment = require("Comment")

        comment.setup()
    end,
}
