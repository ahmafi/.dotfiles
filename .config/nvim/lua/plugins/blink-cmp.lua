return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets', 'folke/lazydev.nvim' },
    version = '1.*',
    config = function()
        require("blink.cmp").setup({
            keymap = { preset = "enter" },
            completion = { documentation = { auto_show = true } },
            sources = {
                default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        })
    end
}
