require('telescope').setup({
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    color_devicons = true,

    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    file_ignore_patterns = { "^%.git/", "^node_modules" },
    mappings = {
      i = { ["<c-t>"] = require("trouble.providers.telescope").open_with_trouble },
      n = { ["<c-t>"] = require("trouble.providers.telescope").open_with_trouble },
    },
 },
  pickers = {
    previewers = false
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  }
})
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('git_worktree')

vim.keymap.set('n', "<M-p>", ":Telescope")
vim.keymap.set('n', "<leader>fp", function()
  require('telescope.builtin').git_files()
end)
vim.keymap.set('n', "<leader>ff", function()
  require('telescope.builtin').find_files({ hidden = true })
end)
vim.keymap.set('n', "<leader>fg", function()
  require('telescope.builtin').live_grep({ hidden = true })
end)
vim.keymap.set('n', "<leader>fr", function()
  require('telescope.builtin').lsp_references()
end)
vim.keymap.set('n', "<leader>ft", function()
  require('telescope.builtin').treesitter()
end)
vim.keymap.set('n', "<leader>fb", function()
  require('telescope.builtin').buffers()
end)
vim.keymap.set('n', "<leader>fh", function()
  require('telescope.builtin').help_tags()
end)
vim.keymap.set('n', "<leader>gb", function()
  require('telescope.builtin').git_branches()
end)
vim.keymap.set('n', "<leader>'", function()
  require('telescope.builtin').find_files({ prompt_title = "< VimRC >", cwd = "~/.dotfiles/", hidden = true })
end)
vim.keymap.set('n', "<leader>gw", function()
  require('telescope').extensions.git_worktree.git_worktrees()
end)
vim.keymap.set('n', "<leader>gm", function()
  require('telescope').extensions.git_worktree.create_git_worktree()
end)
vim.keymap.set('n', "<leader>vh", function()
  require('telescope.builtin').help_tags()
end)
vim.keymap.set('n', "<leader>qf", function()
  require('telescope.builtin').quickfix()
end)
