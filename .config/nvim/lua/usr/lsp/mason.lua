return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
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
                "gopls",
                "jdtls",
                "bashls",
                "gradle_ls",
                "dockerls",
                "jsonls",
                -- "groovyls",
                "helm_ls",
                "tsserver",
                "html",
                "cssls",
                -- "tailwindcss",
                -- "svelte",
                "lua_ls",
                "emmet_ls",
                "yamlls",
                "zls",
                "texlab",
            },
            automatic_installation = true,
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "goimports",
                "prettierd",
                "shfmt",
                "sqlfmt",
                "stylua",
                "eslint_d",
                "shellcheck",
                "markdownlint",
                "golangci-lint",
                "delve",
                "java-debug-adapter",
                "java-test",
            },
        })
    end,
}
