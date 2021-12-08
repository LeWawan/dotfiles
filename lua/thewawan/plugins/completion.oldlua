local nvim_lsp = require('lspconfig')

-- Cmp autocompletion
local capabilities = require('thewawan.plugins.cmp')

-- Lsp config
local on_attach = require('thewawan.plugins.lsp')

nvim_lsp.tsserver.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = ['typescript'],
}

