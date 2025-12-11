return {
    'stevearc/conform.nvim',
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
                sql = { "sql_formatter" },
                -- go = { "gofumpt" },
                go = { "goimports" },
                -- cmake = { "gersemi" },
                -- javascript = { lsp_format = "first" },
                -- javascriptreact = { lsp_format = "first" },
                -- typescript = { lsp_format = "first" },
                -- typescriptreact = { lsp_format = "first" },
                -- json = { lsp_format = "first" },
                -- jsonc = { lsp_format = "first" },
                -- css = { lsp_format = "first" },
                -- scss = { lsp_format = "first" },
                lua = { lsp_format = "first" },
            },
            format_on_save = {
                lsp_format = "never",
                timeout_ms = 1000,
            }
            -- format_on_save = function(bufnr)
            --     vim.api.nvim_buf_call
            --     print(bufnr)
            --     return {}
            -- end
        })

        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     pattern = "*",
        --     group = vim.api.nvim_create_augroup("FormatConfig", { clear = true }),
        --     callback = function(args)
        --         local ft = vim.bo[args.buf].ft
        --         print('hi' .. ft)
        --         if ft == "typescript" or ft == "typescriptreact" then
        --         require("conform").format({ bufnr = args.buf, name = "biome" })
        --         else
        --            require("conform").format({ bufnr = args.buf })
        --         end
        --     end,
        -- })

        vim.api.nvim_create_autocmd("BufWritePost", {
            desc = "Format after save",
            pattern = "*",
            group = vim.api.nvim_create_augroup("BiomeFixAll", { clear = true }),
            callback = function(ev)
                -- vim.cmd("silent! write")
                local file = vim.api.nvim_buf_get_name(ev.buf)
                vim.fn.jobstart({ "bunx", "biome", "check", "--write", file }, {
                    on_exit = function()
                        -- reload buffer only if file still exists
                        if vim.fn.filereadable(file) == 1 then
                            vim.schedule(function()
                                -- silently reload if file changed on disk
                                vim.cmd("checktime")
                            end)
                        end
                    end,
                })
            end,
        })
    end
}
