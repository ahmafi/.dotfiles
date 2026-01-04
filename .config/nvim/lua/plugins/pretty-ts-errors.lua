return {
    "youyoumu/pretty-ts-errors.nvim",
    config = function()
        require("pretty-ts-errors").setup({
            auto_open = false
        })
    end,
}
