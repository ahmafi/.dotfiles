return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            local nvimTree = require("nvim-tree")
            nvimTree.setup {
                diagnostics = {
                    enable = true,
                    show_on_dirs = true,
                    show_on_open_dirs = true,
                },
                disable_netrw = true,
                hijack_directories = {
                    auto_open = true,
                },
                hijack_netrw = true,
                modified = {
                    enable = true,
                },
                renderer = {
                    full_name = false,
                    highlight_modified = "all",
                },
                respect_buf_cwd = true,
                select_prompts = true,
                sync_root_with_cwd = true,
                update_focused_file = {
                    enable = true,
                },
                -- view = {
                --     float = {
                --         enable = false,
                --     },
                --     width = {
                --         max = -1,
                --     },
                -- },
            }

            local nvimTreeApi = require("nvim-tree.api")

            -- local currentTab = vim.api.nvim_get_current_tabpage()
            -- local tabLatestWindow = {}
            -- if vim.bo.filetype ~= "NvimTree" then
            --     tabLatestWindow[currentTab] = vim.api.nvim_get_current_win()
            -- end

            -- local getFirstNonNvimTreeWin = function()
            --     local wins = vim.api.nvim_list_wins()
            --     local firstNonNvimTreeWin = 0
            --     for i, v in ipairs(wins) do
            --         if vim.api.nvim_win_get_buf(v) ~= "NvimTree" then
            --             return v
            --         end
            --     end
            --     return 0
            -- end

            -- vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
            --     callback = function()
            --         local currentTab = vim.api.nvim_get_current_tabpage()
            --         print("hi" .. vim.bo.filetype)
            --         if vim.bo.filetype ~= "NvimTree" then
            --             tabLatestWindow[currentTab] = vim.api.nvim_get_current_win()
            --             print(vim.inspect(tabLatestWindow))
            --         end
            --     end
            -- })

            local toggleFocus = function()
                if vim.bo.filetype == "NvimTree" then
                    vim.cmd("wincmd p")
                else
                    nvimTreeApi.tree.open()
                end
            end

            vim.keymap.set("n", "t", toggleFocus)
        end,
    }
}
