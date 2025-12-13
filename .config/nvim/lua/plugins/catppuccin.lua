return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = 'macchiato',
                float = {
                    transparent = false,
                    solid = false
                },
                integrations = {
                    -- blink_cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    fzf = true,
                    diffview = true,
                    fidget = true,
                    hop = true,
                    mason = true,
                    notify = true,
                },
                no_underline = true, -- Force no underline
            })

            vim.cmd.colorscheme("catppuccin")
        end
    }
}
