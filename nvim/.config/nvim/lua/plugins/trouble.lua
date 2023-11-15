return {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    keys = {
      -- Add all my keymaps
      { "n", "<C-q>", "<cmd>TroubleToggle<cr>" },
      { "n", "<C-n>", "<cmd>TroubleToggle lsp_document_diagnostics<cr>" },
      { "n", "<C-p>", "<cmd>TroubleToggle lsp_document_diagnostics<cr>" },
      { "n", "<leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>" },
      { "n", "<leader>xd", "<cmd>TroubleToggle lsp_document_diagnostics<cr>" },
      { "n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>" },
      { "n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>" },
      { "n", "gR", "<cmd>TroubleToggle lsp_references<cr>" },
    },
  },
}
