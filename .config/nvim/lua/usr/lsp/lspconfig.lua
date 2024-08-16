return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "folke/neodev.nvim",
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        local neodev = require("neodev")

        neodev.setup({})

        local lspconfig = require("lspconfig")

        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local on_attach = require("usr.core.lspkeymaps").on_attach

        local capabilities = cmp_nvim_lsp.default_capabilities()

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        lspconfig["gopls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["bashls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["gradle_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["dockerls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["zls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["jsonls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                json = {
                    -- Schemas https://www.schemastore.org
                    schemas = {
                        {
                            fileMatch = { "package.json" },
                            url = "https://json.schemastore.org/package.json",
                        },
                        {
                            fileMatch = { "tsconfig*.json" },
                            url = "https://json.schemastore.org/tsconfig.json",
                        },
                        {
                            fileMatch = {
                                ".prettierrc",
                                ".prettierrc.json",
                                "prettier.config.json",
                            },
                            url = "https://json.schemastore.org/prettierrc.json",
                        },
                        {
                            fileMatch = { ".eslintrc", ".eslintrc.json" },
                            url = "https://json.schemastore.org/eslintrc.json",
                        },
                        {
                            fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
                            url = "https://json.schemastore.org/babelrc.json",
                        },
                        {
                            fileMatch = { "lerna.json" },
                            url = "https://json.schemastore.org/lerna.json",
                        },
                        {
                            fileMatch = { "now.json", "vercel.json" },
                            url = "https://json.schemastore.org/now.json",
                        },
                        {
                            fileMatch = {
                                ".stylelintrc",
                                ".stylelintrc.json",
                                "stylelint.config.json",
                            },
                            url = "http://json.schemastore.org/stylelintrc.json",
                        },
                    },
                },
            },
        })

        -- lspconfig["groovyls"].setup({
        -- 	cmd = { "groovy-language-server" },
        -- 	capabilities = capabilities,
        -- 	on_attach = on_attach,
        -- })

        lspconfig["helm_ls"].setup({
            filetypes = { "helm" },
            cmd = { "helm_ls", "serve" },
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["texlab"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- lspconfig["yamlls"].setup({
        -- 	capabilities = capabilities,
        -- 	on_attach = on_attach,
        -- 	-- settings = {
        -- 	-- 	yaml = {
        -- 	-- 		schemas = {
        -- 	-- 			kubernetes = "*.yaml",
        -- 	-- 			["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        -- 	-- 			["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        -- 	-- 			["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
        -- 	-- 			["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        -- 	-- 			["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        -- 	-- 			["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
        -- 	-- 			["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        -- 	-- 			["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
        -- 	-- 			["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
        -- 	-- 			["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
        -- 	-- 			["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
        -- 	-- 			["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
        -- 	-- 		},
        -- 	-- 	},
        -- 	-- },
        -- })

        lspconfig["html"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["tsserver"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["cssls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure tailwindcss server
        -- lspconfig["tailwindcss"].setup({
        --   capabilities = capabilities,
        --   on_attach = on_attach,
        -- })

        -- configure svelte server
        -- lspconfig["svelte"].setup({
        --   capabilities = capabilities,
        --   on_attach = function(client, bufnr)
        --     on_attach(client, bufnr)
        --
        --     vim.api.nvim_create_autocmd("BufWritePost", {
        --       pattern = { "*.js", "*.ts" },
        --       callback = function(ctx)
        --         if client.name == "svelte" then
        --           client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
        --         end
        --       end,
        --     })
        --   end,
        -- })

        -- configure graphql language server
        -- lspconfig["graphql"].setup({
        --     capabilities = capabilities,
        --     on_attach = on_attach,
        --     filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        -- })

        lspconfig["emmet_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })

        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    -- make the language server recognize "vim" global
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- make language server aware of runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
    end,
}
