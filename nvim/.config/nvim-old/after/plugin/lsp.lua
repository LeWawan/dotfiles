local Remap = require('thewawan.keymap')
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap

vim.cmd('set completeopt=menu,menuone,noselect')

-- Neodev - https://github.com/folke/neodev.nvim
require("neodev").setup()

-- Mason setup - https://github.com/williamboman/mason.nvim
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "sumneko_lua", "rust_analyzer" },
  automatic_installation = false,
}

local lspconfig = require("lspconfig")

-- Cmp Setup - https://github.com/hrsh7th/nvim-cmp
local cmp = require('cmp')
local lspkind = require('lspkind')

local source_mapping = {
  buffer = '[Buffer]',
  nvim_lsp = '[Lsp]',
  nvim_lua = '[Lua]',
  cmp = '[Cmp]',
  path = '[Path]'
}

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Enter>'] = cmp.mapping.confirm({ select = true }),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      local menu = source_mapping[entry.source.name]
      vim_item.menu = menu
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  },
    {
      { name = 'buffer' }
    })
})

-- Custom lsp handlers
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
})

local function config(_config)
  return vim.tbl_deep_extend("force", {
    lsp_flags = {
      -- This is the default in Nvim 0.7+ (this may be remove...)
      debounce_text_changes = 150,
    },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    on_attach = function()
      nnoremap("<leader>e", function() vim.diagnostic.open_float() end)
      -- nnoremap("<leader>q", function() vim.diagnostic.setloclist() end)
      nnoremap("gd", function() vim.lsp.buf.definition() end)
      nnoremap("gr", function() vim.lsp.buf.references() end)
      nnoremap("K", function() vim.lsp.buf.hover() end)
      nnoremap("<leader>ws", function() vim.lsp.buf.workspace_symbol() end)
      nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
      nnoremap("[d", function() vim.diagnostic.goto_next() end)
      nnoremap("]d", function() vim.diagnostic.goto_prev() end)
      vnoremap("<leader>a", function() vim.lsp.buf.code_action() end)
      nnoremap("<leader>rr", function() vim.lsp.buf.references() end)
      nnoremap("<leader>rn", function() vim.lsp.buf.rename() end)
      vnoremap("<leader>f", function() vim.lsp.buf.formatting() end)
      nnoremap("<leader>F", function() vim.lsp.buf.formatting() end)
    end,
  }, _config or {})
end

-- Typescript config
lspconfig.tsserver.setup(config())

-- Vuejs config
lspconfig.volar.setup(config({
  init_options = {
    typescript = {
      -- serverPath = '~/.nvm/versions/node/v18.12.0/lib/node_modules/npm/node_modules/typescript/lib/tsserverlibrary.js',
      tsdk = '/Users/erwan/.nvm/versions/node/v18.12.0/lib/node_modules/npm/node_modules/typescript/lib'
      -- Alternative location if installed as root:
      -- serverPath = '/usr/local/lib/node_modules/typescript/lib/tsserverlibrary.js'
    }
  },
  settings = {
    format = {
      semicolons = 'remove'
    }
  }
}))
-- Outdated vue...
-- require 'lspconfig'.vuels.setup(config({}))

-- Rust config
lspconfig.rust_analyzer.setup(config({
  cmd = {
    "rustup", "run", "stable", "rust-analyzer"
  }
}))

-- Lua config
lspconfig.sumneko_lua.setup(config({
  -- cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
  settings = {
    Lua = {
      runtime = {
        version = 'Lua 5.3',
        path = {
          '?.lua',
          '?/init.lua',
          vim.fn.expand '~/.luarocks/share/lua/5.3/?.lua',
          vim.fn.expand '~/.luarocks/share/lua/5.3/?/init.lua',
          '/usr/share/5.3/?.lua',
          '/usr/share/lua/5.3/?/init.lua'
        }
      },
      workspace = {
        library = {
          vim.fn.expand '~/.luarocks/share/lua/5.3',
          '/usr/share/lua/5.3'
        }
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'use', 'vim', 'require', 'os', 'package', 'nvim' },
      },
      telemetry = {
        enable = false
      },
      completion = {
        callSnippet = 'Replace'
      }
    },
  },
}))

-- Html + Emmet
lspconfig.html.setup(config())

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.emmet_ls.setup(config({
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
  init_options = {
      html = {
        options = {
          ["bem.enabled"] = true,
        },
      },
    }
}))

-- Tailwindcss
lspconfig.tailwindcss.setup(config({}))

-- Markdown
lspconfig.marksman.setup(config())

-- Php
lspconfig.intelephense.setup(config({}))
