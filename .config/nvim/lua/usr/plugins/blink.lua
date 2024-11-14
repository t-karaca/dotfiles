return {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets" },

    version = "v0.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<CR>"] = { "accept", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        },
        nerd_font_variant = "mono",

        -- experimental auto-brackets support
        -- accept = { auto_brackets = { enabled = true } }

        -- experimental signature help support
        trigger = { signature_help = { enabled = true } },
        windows = {
            autocomplete = {
                min_width = 30,
                max_height = 20,
                draw = "reversed",
                border = "solid",
                selection = "manual",
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
                update_delay_ms = 0,
                border = "solid",
            },
            signature_help = {
                border = "solid",
            },
        },

        sources = {
            completion = {
                enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
            },
            providers = {
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",

                    --- *All* of the providers have the following options available
                    --- NOTE: All of these options may be functions to get dynamic behavior
                    --- See the type definitions for more information
                    enabled = true, -- whether or not to enable the provider
                    transform_items = nil, -- function to transform the items before they're returned
                    should_show_items = true, -- whether or not to show the items
                    max_items = nil, -- maximum number of items to return
                    min_keyword_length = 0, -- minimum number of characters to trigger the provider
                    fallback_for = {}, -- if any of these providers return 0 items, it will fallback to this provider
                    score_offset = 10, -- boost/penalize the score of the items
                    override = nil, -- override the source's functions
                },
                lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
            },
        },
    },
}
