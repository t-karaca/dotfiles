local jdtls = require("jdtls")
local mason_registry = require("mason-registry")
local jdtls_dir = mason_registry.get_package("jdtls"):get_install_path()
local lombok_jar = jdtls_dir .. "/lombok.jar"

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.loop.os_homedir() .. "/.jdtls/" .. project_name

local on_attach = require("usr.core.lspkeymaps").on_attach

local debug_adapter_dir = mason_registry.get_package("java-debug-adapter"):get_install_path()
local test_dir = mason_registry.get_package("java-test"):get_install_path()

local bundles = {
    vim.fn.glob(debug_adapter_dir .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(test_dir .. "/extension/server/*.jar", 1), "\n"))

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
    cmd = { jdtls_dir .. "/jdtls", "--jvm-arg=-javaagent:" .. lombok_jar, "-data", workspace_dir },
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
