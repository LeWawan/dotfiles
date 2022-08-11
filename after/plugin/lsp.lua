local Remap = require('thewawan.keymap')
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap

vim.cmd('set completeopt=menu,menuone,noselect')

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
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
		on_attach = function()
      nnoremap("<leader>e", function() vim.diagnostic.open_float() end)
      nnoremap("<leader>q", function() vim.diagnostic.setloclist() end)
			nnoremap("gd", function() vim.lsp.buf.definition() end)
			nnoremap("gr", function() vim.lsp.buf.references() end)
			nnoremap("K", function() vim.lsp.buf.hover() end)
			nnoremap("<leader>ws", function() vim.lsp.buf.workspace_symbol() end)
			nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
			nnoremap("[d", function() vim.diagnostic.goto_next() end)
			nnoremap("]d", function() vim.diagnostic.goto_prev() end)
			nnoremap("<leader>a", function() vim.lsp.buf.code_action() end)
			vnoremap("<leader>a", function() vim.lsp.buf.range_code_action() end)
			nnoremap("<leader>rr", function() vim.lsp.buf.references() end)
			nnoremap("<leader>rn", function() vim.lsp.buf.rename() end)
      vnoremap("<leader>f", function() vim.lsp.buf.formatting() end)
      nnoremap("<leader>F", function() vim.lsp.buf.formatting() end)
		end,
	}, _config or {})
end

lspconfig.sumneko_lua.setup(config({
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim', 'use'},
      },
    },
  },
}))

lspconfig.tsserver.setup(config())
lspconfig.html.setup(config())
lspconfig.rust_analyzer.setup(config())
lspconfig.taplo.setup(config())
lspconfig.marksman.setup(config())

require'lspconfig'.volar.setup(config({
  init_options = {
    typescript = {
      serverPath = '/path/to/.npm/lib/node_modules/typescript/lib/tsserverlib.js'
      -- Alternative location if installed as root:
      -- serverPath = '/usr/local/lib/node_modules/typescript/lib/tsserverlibrary.js'
    }
  }
}))

-- Php
require'lspconfig'.intelephense.setup(config({}))
