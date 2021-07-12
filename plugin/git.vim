" Vim-fugitive
nnoremap <leader>gs :G<CR>
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git pull<CR>

" Git fzf
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 }}
let g:fzf_branch_actions = {
      \ 'track': {
      \   'keymap': 'ctrl-t',
      \ }
      \}
let $FZF_DEFAULT_OPTS='--reverse'
nnoremap <leader>gb :GBranches<CR>
