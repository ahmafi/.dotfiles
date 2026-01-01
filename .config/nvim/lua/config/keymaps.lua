-- Nvim development
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Save file
vim.keymap.set("n", "s", "<cmd>w<cr>")

-- Diagnostics
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ float = true, count = 1 })
end)

vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ float = true, count = -1 })
end)

vim.keymap.set("n", "]e", function()
    vim.diagnostic.jump({ severity = "ERROR", float = true, count = 1 })
end)

vim.keymap.set("n", "[e", function()
    vim.diagnostic.jump({ severity = "ERROR", float = true, count = -1 })
end)

-- Buffer switch
-- vim.keymap.set({ "n", "i" }, "<C-n>", function ()
--
-- end)
vim.keymap.set({ "n", "i" }, "<C-n>", "<C-^>")

-- Sane defaults
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>")

-- Moving on wrapped lines
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set({ "n", "l" }, "L", "$")
vim.keymap.set({ "n", "l" }, "H", "^")

vim.keymap.set({ "n", "v" }, "<A-j>", ":m .+1<cr>==")
vim.keymap.set({ "n", "v" }, "<A-k>", ":m .-2<cr>==")

-- LSP
vim.keymap.set("n", "<leader>a", function()
    vim.lsp.buf.code_action({
        context = {
            only = { "quickfix", "refactor", "source" },
            diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
        }
    })
end)

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

vim.keymap.set('n', 'K', function() vim.lsp.buf.hover { border = 'rounded' } end)
