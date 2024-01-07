return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  requires = {
    "kyazdani42/nvim-web-devicons",
    "kyazdani42/nvim-tree.lua",
  },
  config = function ()
    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true

    require('nvim-tree').setup()

    vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
  end
}
