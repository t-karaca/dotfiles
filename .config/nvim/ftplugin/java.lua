local jdtls = require("jdtls")
local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.expand("$HOME/.jdtls/") .. project_name

local on_attach = require("usr.core.lspkeymaps").on_attach

local bundles = vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar", false, true)

vim.list_extend(bundles, vim.fn.glob("$MASON/share/java-test/*.jar", false, true))

vim.keymap.set("n", "<leader>rj", jdtls.pick_test, { desc = "Pick java test to run" })
vim.keymap.set("n", "<leader>rr", function()
    local dap = require("dap")

    dap.run({
        type = "java",
        name = "Remote Debug",
        request = "attach",
        hostName = "127.0.0.1",
        port = 5005,
    })
end, { desc = "Java Remote Debug" })

local config = {
    cmd = { "jdtls", "--jvm-arg=-javaagent:" .. lombok_jar, "-data", workspace_dir },
    root_dir = vim.fs.dirname(
        vim.fs.find({ "gradlew", ".git", "mvnw", "settings.gradle", "pom.xml" }, { upward = true })[1]
    ),
    on_attach = on_attach,
    init_options = {
        bundles = bundles,
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
    },
    settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            signatureHelp = {
                enabled = true,
            },
            contentProvider = {
                preferred = "fernflower",
            },
            settings = {
                url = vim.fn.stdpath("config") .. "/jdtls.properties",
            },
        },
    },
}

jdtls.start_or_attach(config)
