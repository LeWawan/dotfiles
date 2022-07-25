  require("nvim-lsp-installer").setup {}
  local lspconfig = require("lspconfig")

  local function on_attach(client, bufnr)
      -- set up buffer keymaps, etc.
  end

  lspconfig.sumneko_lua.setup { 
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
      },
    },
  }

  lspconfig.tsserver.setup { on_attach = on_attach }
