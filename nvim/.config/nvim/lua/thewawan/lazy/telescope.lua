return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local telescope = require('telescope.builtin')
      local trouble = require("trouble.providers.telescope")

      vim.keymap.set('n', "<leader>fp", function() telescope.git_files() end)
      vim.keymap.set('n', "<leader>ff", function() telescope.find_files({ hidden = true }) end)
      vim.keymap.set('n', "<leader>fg", function() telescope.live_grep({ hidden = true }) end)
      vim.keymap.set('n', "<leader>fr", function() telescope.lsp_references() end)
      vim.keymap.set('n', "<leader>ft", function() telescope.treesitter() end)
      vim.keymap.set('n', "<leader>fb", function() telescope.buffers() end)
      vim.keymap.set('n', "<leader>fh", function() telescope.help_tags() end)
      vim.keymap.set('n', "<leader>gb", function() telescope.git_branches() end)
      vim.keymap.set('n', "<leader>'",
        function() telescope.builtin.find_files({ prompt_title = "< VimRC >", cwd = "~/.dotfiles/", hidden = true }) end)
      vim.keymap.set('n', "<leader>vh", function() telescope.builtin.help_tags() end)

      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<C-q>"] = trouble.open_with_trouble,
              ["<C-t>"] = trouble.open_with_trouble,
            },
            n = {
              ["<C-q>"] = trouble.open_with_trouble,
              ["<C-t>"] = trouble.open_with_trouble,
            },
          },
        }
      })
    end
  },

}
