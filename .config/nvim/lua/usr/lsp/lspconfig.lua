return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "antosha417/nvim-lsp-file-operations", config = true },
        "b0o/schemastore.nvim",
        "williamboman/mason.nvim",
        "someone-stole-my-name/yaml-companion.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")

        local on_attach = require("usr.core.lspkeymaps").on_attach

        local capabilities = require("blink.cmp").get_lsp_capabilities()

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- local configs = require("lspconfig.configs")

        -- configs["emmylua"] = {
        --     default_config = {
        --         cmd = { "/mnt/data/Downloads/EmmyLua.LanguageServer/EmmyLua.LanguageServer" },
        --         -- cmd = { "java", "-cp", "/mnt/data/Downloads/EmmyLua-LS-all.jar", "com.tang.vscode.MainKt" },
        --         filetypes = { "lua" },
        --         root_dir = function(fname)
        --             return lspconfig.util.find_git_ancestor(fname)
        --         end,
        --         -- init_options = {
        --         --     configFiles = { uri = ".luarc.json", workspace = "Content/Script" },
        --         -- },
        --         settings = {},
        --     },
        -- }

        -- lspconfig["emmylua"].setup({
        --     capabilities = capabilities,
        --     on_attach = on_attach,
        -- })

        lspconfig["mesonlsp"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["clangd"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["lemminx"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

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

        lspconfig["rust_analyzer"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["glsl_analyzer"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["jsonls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        })

        lspconfig["helm_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["texlab"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["angularls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = lspconfig.util.root_pattern("angular.json", "nx.json", "package.json"),
        })

        local yamlCfg = require("yaml-companion").setup({
            schemas = require("schemastore").yaml.schemas(),
            lspconfig = {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    redhat = { telemetry = { enabled = false } },
                    yaml = {
                        schemaStore = {
                            enable = false,
                            url = "",
                        },
                        schemas = require("schemastore").yaml.schemas(),
                    },
                },
            },
        })

        lspconfig["yamlls"].setup(yamlCfg)

        -- lspconfig["yamlls"].setup({
        --     capabilities = capabilities,
        --     on_attach = on_attach,
        --     settings = {
        --         yaml = {
        --             schemaStore = {
        --                 -- You must disable built-in schemaStore support if you want to use
        --                 -- this plugin and its advanced options like `ignore`.
        --                 enable = false,
        --                 -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        --                 url = "",
        --             },
        --             schemas = require("schemastore").yaml.schemas(),
        --         },
        --     },
        -- })

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
            filetypes = { "html", "htmlangular", "templ" },
        })

        lspconfig["ts_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            init_options = {
                preferences = {
                    importModuleSpecifierPreference = "non-relative",
                },
            },
        })

        lspconfig["cssls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["tailwindcss"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end,
}
