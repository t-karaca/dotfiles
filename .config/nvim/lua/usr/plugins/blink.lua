return {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets" },

    version = "*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "none",
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<Tab>"] = { "accept", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },
            ["<C-e>"] = { "snippet_forward", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        cmdline = {
            keymap = {
                preset = "none",
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<CR>"] = { "accept_and_enter", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            },
            completion = {
                menu = {
                    auto_show = true,
                },
                list = {
                    selection = {
                        auto_insert = true,
                        preselect = false,
                    },
                },
            },
        },
        completion = {
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = false,
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 100,
                window = {
                    border = "solid",
                },
            },
            menu = {
                border = "solid",
                min_width = 30,
                max_height = 20,
                scrollbar = false,
                draw = {
                    padding = 1,
                    columns = {
                        { "label", gap = 1 },
                        { "kind_icon", "kind", gap = 1 },
                    },
                },
            },
            ghost_text = {
                enabled = true,
            },
        },
        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
                lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
            },
        },
    },
}
