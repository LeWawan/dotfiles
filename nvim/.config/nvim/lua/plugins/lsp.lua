return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        volar = {
          filetypes = { "vue", "javascript", "typescript", "typescriptreact" },
        },
        -- eslint = function()
        --   require("lazyvim.util").lsp.on_attach(function(client)
        --     if client.name == "eslint" then
        --       client.server_capabilities.documentFormattingProvider = true
        --     elseif client.name == "tsserver" or client.name == "volar" then
        --       client.server_capabilities.documentFormattingProvider = false
        --     end
        --   end)
        -- end,
        -- pyright will be automatically installed with mason and loaded with lspconfig
      },
    },
  },
}
