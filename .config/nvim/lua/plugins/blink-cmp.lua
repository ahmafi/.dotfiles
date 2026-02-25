return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets', 'folke/lazydev.nvim' },
    version = '1.*',
    config = function()
        require("blink.cmp").setup({
            snippets = { preset = 'luasnip' },
            keymap = { preset = "enter" },
            completion = {
                documentation = { auto_show = true },
                menu = { border = 'rounded' },
                accept = { auto_brackets = { enabled = false }, }
            },
            sources = {
                default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
                per_filetype = {
                    sql = { 'lsp', 'snippets', 'dadbod', 'buffer' },
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
            signature = { enabled = true },
        })

        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
    end
}
