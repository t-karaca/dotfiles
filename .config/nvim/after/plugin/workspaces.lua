---@type string[]
local tmuxSessionDirs

local find_dirs = function(opts)
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local builtin = require("telescope.builtin")

    local homeDir = vim.loop.os_homedir()

    opts = opts or {}
    if not tmuxSessionDirs then
        local dirs = os.getenv("TMUX_SESSION_FIND_DIRS")
        if dirs ~= nil then
            tmuxSessionDirs = vim.split(dirs, " ")
        end
    end

    local args = { "fd", "-td", "--exact-depth", "1", "." }

    for _, dir in ipairs(tmuxSessionDirs) do
        table.insert(args, dir)
    end

    pickers
        .new(opts, {
            prompt_title = "Workspaces",
            finder = finders.new_oneshot_job(args, { cwd = homeDir }),
            previewer = conf.grep_previewer(opts),
            sorter = conf.file_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)

                    local selection = action_state.get_selected_entry()

                    builtin.find_files({
                        cwd = homeDir .. "/" .. selection[1],
                    })
                end)
                return true
            end,
        })
        :find()
end

-- return require("telescope").register_extension({
-- 	exports = { workspaces = find_dirs },
-- })

vim.keymap.set("n", "<leader>fw", find_dirs, { desc = "Find workspaces" })
