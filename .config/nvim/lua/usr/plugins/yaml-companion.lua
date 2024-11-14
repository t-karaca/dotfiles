return {
    "someone-stole-my-name/yaml-companion.nvim",
    lazy = true,
    enabled = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("telescope").load_extension("yaml_schema")

        -- local cfg = require("yaml-companion").setup({
        --     schemas = require("schemastore").yaml.schemas(),
        -- })
        -- -- cfg.filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" }
        --
        -- require("lspconfig")["yamlls"].setup(cfg)
    end,
}
