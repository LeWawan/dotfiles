local Remap = require('thewawan.keymap')
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap

vim.cmd('set completeopt=menu,menuone,noselect')

-- Mason setup
require('mason').setup()

-- CMP Setup
local cmp = require('cmp')
local lspkind = require('lspkind')

local source_mapping = {
  buffer = '[Buffer]',
  nvim_lsp = '[LSP]',
  nvim_lua = '[Lua]',
  cmp = '[Cmp]',
  path = '[Path]'
}

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
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


require("nvim-lsp-installer").setup {}
local lspconfig = require("lspconfig")

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
})

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local function config(_config)
  return vim.tbl_deep_extend("force", {
    lsp_flags = lsp_flags,
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


local sumneko_root_path = "/Users/erwan/local_libs/sumneko"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"
local runtime_path = vim.split(package.path, ';')
lspconfig.sumneko_lua.setup(config({
  cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'use', 'vim', 'require', 'os', 'package' },
      },
      workspace = {
        -- library = vim.api.nvim_get_runtime_file('', true)
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
        }
      },
      telemetry = {
        enable = false
      }
    },
  },
}))

lspconfig.vls.setup(config())
lspconfig.tsserver.setup(config())
lspconfig.html.setup(config())
lspconfig.rust_analyzer.setup(config())
lspconfig.taplo.setup(config())
lspconfig.marksman.setup(config())

-- Vuejs
require 'lspconfig'.volar.setup(config({
  init_options = {
    typescript = {
      -- serverPath = '~/.nvm/versions/node/v18.12.0/lib/node_modules/npm/node_modules/typescript/lib/tsserverlibrary.js',
      -- @TODO fix check
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

require 'lspconfig'.vuels.setup(config({}))

-- Tailwindcss
lspconfig.tailwindcss.setup(config({
  handlers = {
    ["tailwindcss/getConfiguration"] = function (_, _, params, _, bufnr, _)
      -- tailwindcss lang server waits for this repsonse before providing hover
      vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id })
    end
  },
  settings = {},
  flags = { debounce_text_changes = 150, }
}))

-- Php
require 'lspconfig'.intelephense.setup(config({}))

-- cpp
-- require 'lspconfig'.clangd.setup(config({}))

-- prisma
require 'lspconfig'.prismals.setup(config({}))

-- Treesitter
require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  ensure_installed = "typescript",
  highlight = { enable = true },
}

--
-- Emmet
local configs = require'lspconfig.configs'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

if not configs.ls_emmet then
  configs.ls_emmet = {
    default_config = {
      cmd = { 'emmet_ls', '--stdio' };
      filetypes = {
        'html',
        'vue',
        'css',
        'scss',
        'javascriptreact',
        'typescriptreact',
        'haml',
        'xml',
        'xsl',
        'pug',
        'slim',
        'sass',
        'stylus',
        'less',
        'sss',
        'hbs',
        'handlebars',
      };
      root_dir = function()
        return vim.loop.cwd()
      end;
      settings = {};
    };
  }
end

lspconfig.emmet_ls.setup(config({}))
