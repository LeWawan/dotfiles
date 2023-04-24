-- Mappings
vim.cmd('set completeopt=menu,menuone,noselect')

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
  -- attach twoslash queries
  require("twoslash-queries").attach(client, bufnr)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  -- Goto keymaps
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)

  -- Show keymaps
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

  -- Workspace keymaps
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function config(_config)
  return vim.tbl_deep_extend('force', {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = flags
  }, _config or {})
end

local cmp = require('cmp')
local lspkind = require('lspkind')

local source_mapping = {
  buffer = '[Buffer]',
  nvim_lsp = '[Lsp]',
  nvim_lua = '[Lua]',
  vsnip = '[Vsnip]',
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
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
  },
  {
    { name = 'buffer' }
  })
})

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup()

local lspconfig = require('lspconfig')

require('mason').setup()

local basic_servers = {
  'tsserver',
  'html',
  'tailwindcss',
  'marksman',
  'intelephense',
  'eslint'
}

require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'rust_analyzer',
    'tsserver',
    'volar',
    unpack(basic_servers),
  }
})

for _key, value in pairs(basic_servers) do
  lspconfig[value].setup(config())
end

lspconfig.lua_ls.setup(config({
  settings = {
    Lua = {
      diagnostics = {
        global = { 'vim' }
      },
      completion = {
        callSnippet = "Replace"
      }
    }
  }
}))

-- Typescript config
lspconfig.tsserver.setup(config())

-- Vuejs config
lspconfig.volar.setup(config({
  init_options = {
    typescript = {
      -- serverPath = '~/.nvm/versions/node/v18.12.0/lib/node_modules/npm/node_modules/typescript/lib/tsserverlibrary.js',
      tsdk = '/home/wawan/.local/share/fnm/node-versions/v18.16.0/installation/lib/node_modules/typescript/lib'
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

-- Rust config
lspconfig.rust_analyzer.setup(config({
  cmd = {
    "rustup", "run", "stable", "rust-analyzer"
  }
}))

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
