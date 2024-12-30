return {
    "gelguy/wilder.nvim",
    enabled = false,
    config = function()
        local wilder = require("wilder")

        wilder.setup({ modes = { ":", "/", "?" } })

        -- wilder.set_option("pipeline", {
        --     wilder.branch(
        --         -- wilder.python_file_finder_pipeline({
        --         --     file_command = { "fd", "-tf" },
        --         --     dir_command = { "fd", "-td" },
        --         --     -- use {'cpsm_filter'} for performance, requires cpsm vim plugin
        --         --     -- found at https://github.com/nixprime/cpsm
        --         --     filters = { "fuzzy_filter", "difflib_sorter" },
        --         -- }),
        --         wilder.cmdline_pipeline()
        --         -- wilder.python_search_pipeline({
        --         --     pattern = "fuzzy",
        --         -- })
        --     ),
        -- })

        local highlighters = {
            wilder.pcre2_highlighter(),
            wilder.basic_highlighter(),
        }

        wilder.set_option(
            "renderer",
            wilder.renderer_mux({
                [":"] = wilder.popupmenu_renderer({
                    highlighter = highlighters,
                    left = { " ", wilder.popupmenu_devicons() },
                    right = { " ", wilder.popupmenu_scrollbar() },
                }),
                ["/"] = wilder.wildmenu_renderer({
                    highlighter = highlighters,
                    separator = " · ",
                    left = { " ", wilder.wildmenu_spinner(), " " },
                    right = { " ", wilder.wildmenu_index() },
                }),
            })
        )
    end,
}
