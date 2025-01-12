return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    cmd = { "Mason" },
    config = function()
        local mason = require("mason")

        local mason_lspconfig = require("mason-lspconfig")

        local mason_tool_installer = require("mason-tool-installer")

        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            ensure_installed = {
                -- Backend
                "gopls",
                "jdtls",
                "clangd",
                "zls",

                -- Config
                "jsonls",
                "yamlls",
                "lemminx",

                -- Other
                "dockerls",
                "gradle_ls",
                "bashls",
                "helm_ls",
                "lua_ls",
                "texlab",

                -- Frontend
                "html",
                "cssls",
                "tailwindcss",
                "ts_ls",
                "angularls",
            },
            automatic_installation = true,
        })

        mason_tool_installer.setup({
            ensure_installed = {
                -- DAP
                "delve",
                "java-debug-adapter",
                "java-test",
                "codelldb",

                -- Linters
                "eslint_d",
                "shellcheck",
                "golangci-lint",
                "hadolint",

                -- Formatters
                "goimports",
                "prettierd",
                "shfmt",
                "sqlfmt",
                "stylua",
                "clang-format",
            },
        })
    end,
}
