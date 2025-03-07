return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
        local masonToolInstaller = require("mason-tool-installer")
        masonToolInstaller.setup({
            ensure_installed = {
                -- web
                "biome",
                "oxlint",
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
                "go-debug-adapter",
                -- sql
                "sql-formatter",
                "sqlfluff",
                "sqls",
                -- lua
                "lua-language-server",
                -- docker
                "docker-language-server",
                "docker-compose-language-service",
                -- markdown
                "remark-language-server",
                -- svelte
                "svelte-language-server",
            },
            auto_update = true,
            debounce_hours = 8,
        })
    end
}
