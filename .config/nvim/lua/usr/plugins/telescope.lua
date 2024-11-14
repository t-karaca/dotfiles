return {
    "nvim-telescope/telescope.nvim",
    version = "*",
    lazy = true,
    cmd = { "Telescope" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    },
                },
                path_display = { "truncate" },
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                winblend = 0,
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                file_sorter = require("telescope.sorters").get_fuzzy_file,
                file_ignore_patterns = { "node_modules", "%.uasset" },
                generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                -- Developer configurations: Not meant for general override
                buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.4,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                extensions_list = { "themes", "terms", "fzf" },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
                buffers = {
                    mappings = {
                        i = {
                            ["<c-x>"] = actions.delete_buffer + actions.move_to_top,
                        },
                    },
                },
            },
        })

        telescope.load_extension("fzf")
    end,
}
