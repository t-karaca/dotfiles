return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-web-devicons",
    },
    cmd = { "NvimTreeToggle" },
    keys = {
        { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    },
    config = function()
        local nvimtree = require("nvim-tree")

        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup({
            disable_netrw = true,
            view = {
                width = function()
                    return math.floor(vim.opt.columns:get() * 0.2)
                end,
                signcolumn = "no",
            },
            renderer = {
                group_empty = true,
                full_name = true,
                indent_markers = {
                    enable = true,
                },
                icons = {
                    show = {
                        -- folder_arrow = false,
                    },
                },
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                api.config.mappings.default_on_attach(bufnr)

                vim.keymap.del("n", "<C-]>", { buffer = bufnr })
                vim.keymap.set("n", "<C-t>", api.tree.change_root_to_node, opts("CD"))
            end,
        })

        vim.cmd("highlight link NvimTreeIndentMarker IblIndent")
    end,
}
