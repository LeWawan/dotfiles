--html support
--https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#html

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.html.setup {
  capabilities = capabilities,
}
