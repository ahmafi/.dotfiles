return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
        local masonToolInstaller = require("mason-tool-installer")
        masonToolInstaller.setup({
            ensure_installed = {
                -- web
                "biome",
                "vue-language-server",
                "vtsls",
                "tailwindcss-language-server",
                -- c/c++
                "clang-format",
                "cmake-language-server",
                "gersemi",
                "neocmakelsp",
                -- go
                "goimports",
                "gopls",
                -- sql
                "sql-formatter",
                "sqlfluff",
                "sqls",
                -- lua
                "lua-language-server",
            },
            auto_update = true,
            debounce_hours = 8,
        })
    end
}
