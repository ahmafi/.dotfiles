return {
    'smoka7/hop.nvim',
    version = "*",
    config = function()
        local hop = require("hop");
        hop.setup({
            keys = 'etovxqpdygfblzhckisuran',
        })

        vim.keymap.set("n", "f", function()
            require('hop').hint_char1()
        end)
    end
}
