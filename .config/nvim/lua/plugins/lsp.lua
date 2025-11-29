return {
    "neovim/nvim-lspconfig",
    dependencies = { 'saghen/blink.cmp' },
    config = function()
        local servers = {
            lua_ls = {},
            vtsls = {},
            biome = {},
            tailwindcss = {},
            docker_language_server = {},
            docker_compose_language_service = {},
            openscad_lsp = {},
            clangd = {
                -- cmd = { "/home/amir/.espressif/tools/esp-clang/esp-19.1.2_20250312/esp-clang/bin/clangd", "--enable-config" }
                cmd = { "clangd", "--enable-config", "--function-arg-placeholders=0" }
            },
            neocmake = {
                cmd = { "neocmakelsp", "stdio" },
                init_options = {
                    format = {
                        enable = true
                    },
                    lint = {
                        enable = true
                    },
                    scan_cmake_in_package = true -- default is true
                }
                -- root_markers = { "CMakeLists.txt" },
                -- filetypes = { "cmake", "CMakeLists.txt" },
            },
            -- sqlls = {},
            sqls = {
                cmd = { "sqls", "--config", vim.loop.cwd() .. "/sqls.yml" },
            },
            -- sqruff = {},
        }

        for server, config in pairs(servers) do
            vim.lsp.config(server, config)
            vim.lsp.enable(server)
        end

        -- vim.lsp.enable("lua_ls")
        -- vim.lsp.enable("vtsls")
        -- vim.lsp.enable("biome")
        -- vim.lsp.enable("tailwindcss")
        -- vim.lsp.enable("docker_language_server")
        -- vim.lsp.enable("docker_compose_language_service")
        -- vim.lsp.enable("openscad_lsp")

        -- vim.api.nvim_create_autocmd("LspAttach", {
        --     callback = function(args)
        --         local client = vim.lsp.get_client_by_id(args.data.client_id)
        --         if not client then return end
        --
        --         -- if client.name == "biome" then
        --         --     vim.api.nvim_create_autocmd("BufWritePre", {
        --         --         group = vim.api.nvim_create_augroup("BiomeFixAll", { clear = true }),
        --         --         callback = function()
        --         --             vim.lsp.buf.code_action({
        --         --                 context = {
        --         --                     only = { "source.fixAll.biome" },
        --         --                     diagnostics = {},
        --         --                 },
        --         --                 apply = true,
        --         --             })
        --         --         end,
        --         --     })
        --         -- end
        --
        --         -- print("not " .. client.name)
        --         -- if client.supports_method("textDocument/formatting") then
        --         --     print(client.name)
        --         --     vim.api.nvim_create_autocmd("BufWritePre", {
        --         --         buffer = args.buf,
        --         --         callback = function()
        --         --             vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        --         --         end
        --         --     })
        --         -- end
        --     end
        -- })
    end
}
