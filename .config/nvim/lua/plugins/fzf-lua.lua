return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")
        local colors = require("catppuccin.palettes").get_palette("macchiato")

        vim.keymap.set("n", "<up>", function()
            local on_exit = function(obj)
                local fzf = require("fzf-lua")
                local utils = require("fzf-lua.utils")
                local lines = utils.strsplit(obj.stdout, "%s+")

                for line in pairs(lines) do

                end

                vim.schedule(function()
                    fzf.fzf_exec(lines)
                end)
            end
            vim.system({
                    "fd",
                    "--color=never",
                    "--hidden",
                    "--type", "f",
                    "--type", "l",
                    "--exclude", ".git"
                },
                { text = true }, on_exit)
        end);

        -- fzf.files({
        -- fn_transform = function(x)
        --     return vim.loop.cwd() .. "/" .. "[0;33m" .. x .. "[0m"
        -- end
        -- })

        fzf.setup({
            fzf_colors = {
                ["fg+"] = { "fg", { "Constant" } }
            },
            winopts = {
                width = 0.5,
                preview = {
                    hidden = true
                },
            },

            oldfiles = {
                cwd_only = true,
                include_current_session = true,
            },
        })

        -- local diffview = ".editorconfig"
        -- vim.fn.matchadd("Constant", ".editorconfig", 1000000)

        vim.keymap.set("n", "<down>", function()
            fzf.combine({ pickers = "oldfiles;files" })
        end);

        vim.keymap.set("n", "<C-j>", function()
            fzf.combine({ pickers = "oldfiles;files" })
        end);

        vim.keymap.set("n", "<leader>sg", fzf.live_grep_native);

        vim.keymap.set("n", "gd", fzf.lsp_definitions);
        vim.keymap.set("n", "gr", fzf.lsp_references);
    end
}
