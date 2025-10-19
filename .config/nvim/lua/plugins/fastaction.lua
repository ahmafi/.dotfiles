return {
    'Chaitanyabsprip/fastaction.nvim',
    config = function()
        require("fastaction").setup({
            register_ui_select = true,
            popup = {
                relative = "cursor",
                hide_cursor = false,
                border = "rounded",
            }
        })
    end
}
