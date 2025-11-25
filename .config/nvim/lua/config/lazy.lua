-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit colour
vim.opt.termguicolors = true

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.spell = false
vim.opt.termbidi = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.breakindent = true -- wrap indent
vim.opt.signcolumn = "yes"
vim.opt.timeoutlen = 300
vim.opt.updatetime = 300
vim.opt.cursorline = true
vim.opt.syntax = "off"
vim.opt.spell = false

vim.api.nvim_command('filetype indent off')
vim.opt.smartindent = false

vim.diagnostic.config({
    float = { source = true },
    severity_sort = true,
    virtual_text = { severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN } },
})

-- rtl support
vim.opt.termbidi = true

vim.filetype.add({
    pattern = {
        ["compose.*%.ya?ml"] = "yaml.docker-compose",
        ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
    },
})

-- TODO:
-- - fold
-- - indent

require("config.auto-cmd")
require("config.keymaps")
require("config.test")

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "catppuccin" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
    change_detection = { enabled = false }
})
