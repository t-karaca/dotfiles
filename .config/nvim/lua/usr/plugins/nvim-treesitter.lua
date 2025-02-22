return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        local configs = require("nvim-treesitter.configs")

        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

        vim.filetype.add({
            pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
        })


        vim.filetype.add({
            pattern = { [".*%.ftl"] = "freemarker" },
        })

        -- vim.filetype.add({
        --     filename = {
        --         ["docker-compose.yml"] = "yaml.docker-compose",
        --         ["docker-compose.yaml"] = "yaml.docker-compose",
        --     },
        -- })

        -- parser_config["freemarker"] = {
        --     install_info = {
        --         url = "https://github.com/Jake-Nolder/tree-sitter-freemarker",
        --         files = { "src/parser.c" },
        --     },
        --     filetype = "freemarker",
        -- }

        parser_config["gotmpl"] = {
            install_info = {
                url = "https://github.com/ngalaiko/tree-sitter-go-template",
                files = { "src/parser.c" },
            },
            -- filetype = "gotmpl",
            -- used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
        }

        configs.setup({
            ensure_installed = {
                "bash",
                "css",
                "csv",
                "dockerfile",
                "go",
                "gomod",
                "gosum",
                "gowork",
                "graphql",
                "groovy",
                "html",
                "java",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "proto",
                "python",
                "scss",
                "sql",
                "toml",
                "typescript",
                "vim",
                "xml",
                "yaml",
                "zig",
            },
            modules = {},
            ignore_install = {},
            sync_install = false,
            auto_install = true,
            highlight = { enable = true, disable = { "scss" } },
            indent = { enable = true },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
            },
        })
    end,
}
