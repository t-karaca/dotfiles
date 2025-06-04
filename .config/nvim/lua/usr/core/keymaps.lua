vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Resume last search" })
vim.keymap.set("n", "<leader>fa", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope git_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Find recently opened files" })
vim.keymap.set("n", "<leader>ft", "<cmd>Telescope filetypes<CR>", { desc = "Set filetype" })
-- vim.keymap.set("n", "<leader>fy", "<cmd>Telescope yaml_schema<CR>", { desc = "Set yaml schema" })
vim.keymap.set(
    "n",
    "<leader>fs",
    "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
    { desc = "Dynamic workspace symbols" }
)

vim.keymap.set("n", "gK", function()
    local new_config = not vim.diagnostic.config().virtual_lines
    local text = not vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_lines = new_config, virtual_text = text })
end)

vim.keymap.set("n", "<leader>bd", "<cmd>bp <bar>bd #<CR>", { desc = "Close current buffer" })

vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle <CR>", { desc = "Toggle NvimTree" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })

vim.keymap.set("n", "H", "zH", { desc = "Half page left" })
vim.keymap.set("n", "L", "zL", { desc = "Half page right" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next occurrence" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous occurrence" })

vim.keymap.set("i", "<C-c>", "<Esc>")
-- vim.keymap.set("i", "jj", "<Esc>")
-- vim.keymap.set("i", "kj", "<Esc>")

vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set({ "n", "v" }, "<C-p>", '"+p', { desc = "Paste from system clipboard" })

vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank into system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank into system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank into system clipboard" })

vim.keymap.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable" })

vim.keymap.set("n", "<leader>ee", "oif err != nil {\nreturn err\n}\n<Esc>")
vim.keymap.set("n", "<leader>ssd", "<cmd>%!sepoctl seal -d<CR>", { desc = "Seal secret for dev" })
vim.keymap.set("n", "<leader>ssl", "<cmd>%!sepoctl seal<CR>", { desc = "Seal secret for local" })
vim.keymap.set("n", "<leader>sud", "<cmd>%!sepoctl seal -d -u<CR>", { desc = "Unseal secret for dev" })
vim.keymap.set("n", "<leader>sul", "<cmd>%!sepoctl seal -u<CR>", { desc = "Unseal secret for local" })
