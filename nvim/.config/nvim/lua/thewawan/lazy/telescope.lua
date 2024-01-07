return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local telescope = require('telescope.builtin')
      vim.keymap.set('n', "<leader>fp", function() telescope.git_files() end)
      vim.keymap.set('n', "<leader>ff", function() telescope.find_files({ hidden = true }) end)
      vim.keymap.set('n', "<leader>fg", function() telescope.live_grep({ hidden = true }) end)
      vim.keymap.set('n', "<leader>fr", function() telescope.lsp_references() end)
      vim.keymap.set('n', "<leader>ft", function() telescope.treesitter() end)
      vim.keymap.set('n', "<leader>fb", function() telescope.buffers() end)
      vim.keymap.set('n', "<leader>fh", function() telescope.help_tags() end)
      vim.keymap.set('n', "<leader>gb", function() telescope.git_branches() end)
      vim.keymap.set('n', "<leader>'",
        function() telescope.find_files({ prompt_title = "< VimRC >", cwd = "~/.dotfiles/", hidden = true }) end)
      vim.keymap.set('n', "<leader>vh", function() telescope.help_tags() end)
    end
  },

}
