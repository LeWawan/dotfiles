local Remap = require("thewawan.keymap")
local nnoremap = Remap.nnoremap

require('telescope').setup({
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    color_devicons = true,

    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    file_ignore_patterns = { "^%.git/", "^node_modules" }
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

nnoremap("<M-p>", ":Telescope")
nnoremap("<leader>fp", function()
    require('telescope.builtin').git_files()
end)
nnoremap("<leader>ff", function()
    require('telescope.builtin').find_files({ hidden = true })
end)
nnoremap("<leader>fg", function()
    require('telescope.builtin').live_grep({ hidden = true })
end)
nnoremap("<leader>fr", function()
    require('telescope.builtin').lsp_references()
end)
nnoremap("<leader>ft", function()
    require('telescope.builtin').treesitter()
end)
nnoremap("<leader>fb", function()
    require('telescope.builtin').buffers()
end)
nnoremap("<leader>gb", function()
    require('telescope.builtin').git_branches()
end)
nnoremap("<leader>'", function()
    require('telescope.builtin').find_files({ prompt_title = "< VimRC >", cwd = "~/.dotfiles/", hidden = true })
end)
nnoremap("<leader>gw", function()
    require('telescope').extensions.git_worktree.git_worktrees()
end)
nnoremap("<leader>gm", function()
    require('telescope').extensions.git_worktree.create_git_worktree()
end)
nnoremap("<leader>vh", function()
    require('telescope.builtin').help_tags()
end)
