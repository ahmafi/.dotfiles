return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")

        fzf.setup({
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

        vim.keymap.set("n", "<down>", function()
            fzf.combine({ pickers = "oldfiles;git_files" })
        end);

        vim.keymap.set("n", "<leader>sg", fzf.live_grep_native);

        vim.keymap.set("n", "gd", fzf.lsp_definitions);
        vim.keymap.set("n", "gr", fzf.lsp_references);
    end
}
