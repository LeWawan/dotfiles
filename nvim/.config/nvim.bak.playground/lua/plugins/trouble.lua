return {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    keys = {
      -- Add all my keymaps
      { "<C-q>", "<cmd>TroubleToggle<cr>" },
      {
        "<C-n>",
        function()
          require("trouble").next({ skip_groups = true, jump = true })
        end,
      },
      {
        "<C-p>",
        function()
          require("trouble").previous({ skip_groups = true, jump = true })
        end,
      },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>" },
      { "gR", "<cmd>TroubleToggle lsp_references<cr>" },
    },
  },
}
