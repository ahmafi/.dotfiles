return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    config = function()
        require("obsidian").setup({
            -- completion = { blink = true },
            daily_notes = { folder = "journal", template = "daily.md" },
            follow_url_func = function(url)
                vim.fn.jobstart({ "xdg-open", url })
            end,
            legacy_commands = false,
            picker = { name = "fzf-lua" },
            templates = { subdir = "templates" },
            ui = { enable = false },
            workspaces = { { name = "default", path = "~/obsidian/default" } },
        })
    end
}
