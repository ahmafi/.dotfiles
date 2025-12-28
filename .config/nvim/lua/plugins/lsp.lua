return {
    "neovim/nvim-lspconfig",
    dependencies = { 'saghen/blink.cmp' },
    config = function()
        local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
            '/vue-language-server' .. '/node_modules/@vue/language-server'

        local vue_plugin = {
            name = '@vue/typescript-plugin',
            location = vue_language_server_path,
            languages = { 'vue' },
            configNamespace = 'typescript',
        }

        local servers = {
            oxlint = {},
            tailwindcss = {},
            biome = {
                filetypes =
                { "astro", "css", "graphql", "html", "javascript", "javascriptreact", "json", "jsonc", "typescript",
                    "typescript.tsx", "typescriptreact", "vue",
                    -- "svelte"
                }
            },
            lua_ls = {},
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
                root_markers = { "sqls.yml" },
            },
            -- sqruff = {},
            gopls = {},
            remark_ls = {},
            svelte = {},
            buf_ls = {},
        }

        local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

        local vtsls_config = {
            settings = {
                vtsls = {
                    tsserver = {
                        globalPlugins = {
                            vue_plugin,
                        },
                    },
                },
            },
            filetypes = tsserver_filetypes,
            -- TODO: https://github.com/vuejs/language-tools/wiki/Neovim
            -- on_attach = function(client)
            --     if vim.bo.filetype == 'vue' then
            --         existing_capabilities.semanticTokensProvider.full = false
            --     else
            --         existing_capabilities.semanticTokensProvider.full = true
            --     end
            -- end
        }

        local ts_ls_config = {
            init_options = {
                plugins = {
                    vue_plugin,
                },
            },
            filetypes = tsserver_filetypes,
        }

        local vue_ls_config = {}

        vim.lsp.config('vtsls', vtsls_config)
        vim.lsp.config('vue_ls', vue_ls_config)
        vim.lsp.config('ts_ls', ts_ls_config)
        vim.lsp.enable({ 'vtsls', 'vue_ls' })

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
