lua require('thewawan.telescope')
" Telescope conf baby...
nnoremap <Leader>p <cmd>lua require'telescope.builtin'.git_files{}<CR>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>ft <cmd>lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').git_status()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>' <cmd> lua require("telescope.builtin").find_files({ prompt_title = "< VimRC >", cwd = "~/.config/nvim/"})<cr>
nnoremap <leader>ft <cmd> lua require('telescope').extensions.git_worktree.git_worktrees()<cr>
nnoremap <leader>vh <cmd> lua require('telescope.builtin').help_tags()

