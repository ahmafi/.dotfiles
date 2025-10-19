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
        }

        for server, config in pairs(servers) do
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
