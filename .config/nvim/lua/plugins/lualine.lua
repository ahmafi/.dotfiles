return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "catppuccin",
                component_separators = "|",
                section_separators = "",
                disbale_filetypes = {
                    statusline = {
                        "NvimTree",
                        "neo-tree",
                    },
                },
                ignore_focus = {
                    "NvimTree",
                    "neo-tree",
                },
            },
            sections = {
                lualine_a = { "filename" },
                lualine_b = {
                    "branch",
                    "diff",
                    "diagnostics",
                },
                lualine_c = { "%f" },
                lualine_x = {
                    "encoding",
                    "fileformat",
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end
}
