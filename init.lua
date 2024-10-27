--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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

-- Install plugins
require('lazy').setup({
  spec = {

    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    -- LSP Configuration & Plugins
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Useful status updates for LSP
        {
          'j-hui/fidget.nvim',
          config = true
        },

        -- Additional lua configuration, makes nvim stuff amazing!
        {
          "folke/lazydev.nvim",
          ft = "lua", -- only load on lua files
          opts = {
            library = {
              -- See the configuration section for more details
              -- Load luvit types when the `vim.uv` word is found
              { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
          },
        },
        { "Bilal2453/luvit-meta",    lazy = true }, -- optional `vim.uv` typings
      },
    },

    { 'farmergreg/vim-lastplace' },

    {
      -- Autocompletion
      'hrsh7th/nvim-cmp',
      dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',

        -- Adds LSP completion capabilities
        'hrsh7th/cmp-nvim-lsp',

        -- Adds a number of user-friendly snippets
        'rafamadriz/friendly-snippets',

        'hrsh7th/cmp-emoji',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        {
          "David-Kunz/cmp-npm",
          dependencies = { 'nvim-lua/plenary.nvim' },
          ft = "json",
          config = function()
            require('cmp-npm').setup({})
          end
        },
        'SergioRibera/cmp-dotenv',
      },

    },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim',    opts = { preset = "helix" } },
    {
      -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        numhl = true,
        on_attach = function(bufnr)
          vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk,
            { buffer = bufnr, desc = 'Preview git hunk' })

          -- don't override the built-in and fugitive keymaps
          local gs = package.loaded.gitsigns
          vim.keymap.set({ 'n', 'v' }, ']h', function()
            if vim.wo.diff then return ']h' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
          vim.keymap.set({ 'n', 'v' }, '[h', function()
            if vim.wo.diff then return '[h' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
        end,
      },
    },

    -- {
    --   -- Theme inspired by Atom
    --   'navarasu/onedark.nvim',
    --   priority = 1000,
    --   config = function()
    --     vim.cmd.colorscheme 'onedark'
    --   end,
    -- },
    --
    {
      -- Set lualine as statusline
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      -- See `:help lualine.txt`
      opts = {
        options = {
          icons_enabled = true,
          theme = 'onedark',
          component_separators = '|',
          section_separators = '',
          disabled_filetypes = {
            statusline = { "NvimTree" }
          },
          ignore_focus = { "NvimTree" },
        },
        sections = {
          lualine_a = { 'filename' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { '%f' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      },
    },

    {
      -- Add indentation guides even on blank lines
      'lukas-reineke/indent-blankline.nvim',
      -- Enable `lukas-reineke/indent-blankline.nvim`
      -- See `:help indent_blankline.txt`
      main = 'ibl',
      config = function()
        require('ibl').setup {
          indent = { char = '┊' },
          scope = { enabled = false },
        }
      end,
    },

    -- "gc" to comment visual regions/lines
    {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup {
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
      end,
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          -- NOTE: If you are having trouble with this installation,
          --       refer to the README for telescope-fzf-native for more instructions.
          build = 'make',
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
      },
    },

    {
      "nvim-telescope/telescope-frecency.nvim",
      config = function()
        require("telescope").load_extension "frecency"
      end,
    },

    { 
      "smartpde/telescope-recent-files",
      config = function()
        require("telescope").load_extension "recent_files"
      end,
    },

    {
      -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'JoosepAlviste/nvim-ts-context-commentstring'
      },
      build = ':TSUpdate',
    },

    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup {
          update_focused_file = {
            enable = true,
          },
          diagnostics = {
            enable = true,
            show_on_dirs = true,
          },
        }
      end,
    },

    {
      'phaazon/hop.nvim',
      branch = 'v2',
      config = function()
        require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
      end
    },

    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      opts = {}
    },

    {
      'rmagatti/auto-session',
      config = function()
        require("auto-session").setup {
          log_level = "error",
          -- auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
          auto_session_enable_last_session = true,
        }
      end
    },
    {
      'nvimtools/none-ls.nvim',
      dependencies = {
        "nvimtools/none-ls-extras.nvim",
      },
    },
    {
      'davidmh/cspell.nvim',
    },
    {
      'mfussenegger/nvim-lint',
    },
    {
      'mhartington/formatter.nvim',
      config = function()
        local util = require('formatter.util')
        require('formatter').setup {
          logging = true,
          filetype = {
            typescript = {
              function()
                return {
                  exe = "prettierd",
                  args = { util.escape_path(vim.api.nvim_buf_get_name(0)) },
                  stdin = true
                }
              end
            },
            typescriptreact = {
              function()
                return {
                  exe = "prettierd",
                  args = { util.escape_path(vim.api.nvim_buf_get_name(0)) },
                  stdin = true
                }
              end
            },
            javascript = {
              function()
                return {
                  exe = "prettierd",
                  args = { util.escape_path(vim.api.nvim_buf_get_name(0)) },
                  stdin = true
                }
              end
            },
            javascriptreact = {
              function()
                return {
                  exe = "prettierd",
                  args = { util.escape_path(vim.api.nvim_buf_get_name(0)) },
                  stdin = true
                }
              end
            },
            json = {
              function()
                return {
                  exe = "prettierd",
                  args = { util.escape_path(vim.api.nvim_buf_get_name(0)) },
                  stdin = true
                }
              end
            },
            jsonc = {
              function()
                return {
                  exe = "prettierd",
                  args = { util.escape_path(vim.api.nvim_buf_get_name(0)) },
                  stdin = true
                }
              end
            },
            css = {
              function()
                return {
                  exe = "prettierd",
                  args = { util.escape_path(vim.api.nvim_buf_get_name(0)) },
                  stdin = true
                }
              end
            },
            sql = {
              function()
                return {
                  exe = "prettierd",
                  args = { util.escape_path(vim.api.nvim_buf_get_name(0)) },
                  stdin = true
                }
              end
            },
            yaml = {
              function()
                return {
                  exe = "prettierd",
                  args = { util.escape_path(vim.api.nvim_buf_get_name(0)) },
                  stdin = true
                }
              end
            },
            prisma = {
              require("formatter.filetypes.any").remove_trailing_whitespace,
              function()
                -- Ignore already configured types.
                -- local defined_types = require("formatter.config").values.filetype
                -- if defined_types[vim.bo.filetype] ~= nil then
                --   return nil
                -- end
                -- vim.lsp.buf.format({ async = true })
                vim.lsp.buf.format()
              end,
            },
          }
        }
      end
    },
    -- {
    --   "ray-x/lsp_signature.nvim",
    --   event = "VeryLazy",
    --   opts = {},
    --   config = function(_, opts) require 'lsp_signature'.setup(opts) end
    -- },
    {
      "sainnhe/sonokai",
      priority = 1000,
      config = function()
        vim.o.background = 'dark'
        -- vim.g.sonokai_better_performance = 1
        vim.g.sonokai_style = 'andromeda' -- default | atlantis | andromeda | shusia | maia | espersso
        vim.g.sonokai_dim_inactive_windows = 1
        vim.cmd.colorscheme 'sonokai'
      end,
    },
    {
      'christoomey/vim-tmux-navigator'
    },
    {
      'kevinhwang91/nvim-ufo',
      dependencies = {
        'kevinhwang91/promise-async',
        {
          "luukvbaal/statuscol.nvim",
          config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup(
              {
                relculright = true,
                segments = {
                  { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
                  { text = { "%s" },                  click = "v:lua.ScSa" },
                  { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" }
                }
              }
            )
          end
        }
      }
    },
    {
      'sindrets/diffview.nvim'
    },
    {
      "ray-x/go.nvim",
      dependencies = { -- optional packages
        "ray-x/guihua.lua",
      },
      config = function()
        require("go").setup()
      end,
      event = { "CmdlineEnter" },
      ft = { "go", 'gomod' },
      build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    }

    -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
    --       These are some example plugins that I've included in the kickstart repository.
    --       Uncomment any of the lines below to enable them.
    -- require 'kickstart.plugins.autoformat',
    -- require 'kickstart.plugins.debug',

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
    --    up-to-date with whatever is in the kickstart repo.
    --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --
    --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
    -- { import = 'custom.plugins' },

  },
})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,noinsert'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- RTL support
vim.o.termbidi = true

-- indentation width
vim.o.shiftwidth = 2
vim.o.autoindent = true
vim.o.smartindent = true

-- folding
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.filetype.add({
  -- Detect and assign filetype based on the extension of the filename
  extension = {
    env = "conf",
  },
  -- Detect and apply filetypes based on the entire filename
  -- filename = {
  --   [".env"] = "dotenv",
  --   ["env"] = "dotenv",
  --   ["tsconfig.json"] = "jsonc",
  -- },
  -- Detect and apply filetypes based on certain patterns of the filenames
  pattern = {
    -- INFO: Match filenames like - ".env.example", ".env.local" and so on
    ["%.env%.[%w_.-]+"] = "conf",
  },
})

-- [[ Basic Keymaps ]]
vim.keymap.set('n', 's', ':w<cr>')

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- ufo folding
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    preview = {
      filesize_limit = 0.2 -- MB
    }
  },
  pickers = {
    buffers = {
      sort_lastused = true,
    },
    oldfiles = {
      cwd_only = true,
    },
  },
  extensions = {
    recent_files = {
      only_cwd = true,
    },
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader><space>',
  function()
    require('telescope').extensions.recent_files.pick()
  end, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>',
--   function()
--     require('telescope').extensions.frecency.frecency { workspace = 'CWD', path_display = { 'filename_first' } }
--   end, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>ss', require('auto-session.session-lens').search_session, { desc = '[S]earch [S]essions' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim',
    'prisma' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'FormatLSP', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  tsserver = {
    init_options = {
      preferences = {
        -- other preferences...
        -- importModuleSpecifierPreference = 'non-relative',
        -- importModuleSpecifierEnding = 'minimal',
      },
    }
  },
  html = {},
  tailwindcss = {
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            "(?:twMerge|twJoin)\\(([^\\);]*)[\\);]", "[`'\"`]([^'\"`,;]*)[`'\"`]",
          }
        }
      }
    }
  },
  bashls = {},
  cssls = {},
  sqls = {},
  -- lua_ls = {
  --   Lua = {
  --     workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME, "${3rd}/luv/library", "${3rd}/busted/library" } },
  --     telemetry = { enable = false },
  --   },
  -- },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}
require('ufo').setup()

require('mason-tool-installer').setup {
  ensure_installed = {
    -- Linters
    'cspell',
    'eslint_d',
    'shellcheck',

    -- Formatters
    'prettierd',
    'shfmt',
    'sqlfmt'
  }
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
-- require('luasnip.loaders.from_vscode').lazy_load({ paths = { "./snippets" } })
luasnip.config.setup {}

cmp.setup {
  enabled = true,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-x>'] = cmp.mapping(
      cmp.mapping.complete({
        config = {
          sources = cmp.config.sources({
            { name = 'cmp_ai' },
          }),
        },
      }),
      { 'i' }
    ),
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'emoji' },
    { name = 'path' },
    { name = 'lazydev' },
    { name = 'buffer' },
    { name = 'npm',     keyword_length = 4 },
    { name = 'dotenv' },
  },
}

-- [[ configure nvim-tree ]]
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeFocus<cr>", { silent = true, noremap = true })

-- [[ Configure hop ]]
local hop = require('hop')
vim.keymap.set('', 'f', function()
  hop.hint_char1()
end, { remap = true })

-- [[ Configure ALE ]]
-- vim.g.ale_fixers = {
--   typescript = { 'prettierd' },
--   typescriptreact = { 'prettierd' },
--   javascript = { 'prettierd' },
--   javascriptreact = { 'prettierd' },
--   json = { 'prettierd' },
-- }
-- vim.g.ale_fix_on_save = 1

local augroup = vim.api.nvim_create_augroup('autoformat', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = augroup,
  command = 'FormatWrite',
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { "*.go" },
  command = "setlocal shiftwidth=8 tabstop=8 noexpandtab"
})

require('lint').linters_by_ft = {
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})


local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimport()
  end,
  group = format_sync_grp,
})

local cspell = require('cspell')
local null_ls = require("null-ls")
null_ls.setup {
  sources = {
    -- cspell.diagnostics.with({
    --   diagnostics_postprocess = function(diagnostic)
    --     diagnostic.severity = vim.diagnostic.severity["WARN"]
    --   end,
    --   filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "json", "html", "yaml"}
    -- }),
    -- cspell.code_actions,
    -- require("none-ls.code_actions.eslint"),
    -- require("none-ls.diagnostics.eslint_d").with({
    --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE
    -- }),
    -- null_ls.builtins.code_actions.gitsigns.with({
    --   config = {
    --     filter_actions = function(title)
    --       return title:lower():match("blame") == nil   -- filter out blame actions
    --     end,
    --   },
    -- })
  }
}

-- on_attach
-- vim.keymap.set("n", "l", edit_or_open,          {desc="Edit Or Open"})
-- vim.keymap.set("n", "L", vsplit_preview,        {desc="Vsplit Preview"})
-- vim.keymap.set("n", "h", api.tree.close,        {desc="Close"})
-- vim.keymap.set("n", "H", api.tree.collapse_all, {desc="Collapse All"})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
