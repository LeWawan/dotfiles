" im-fugitive
nnoremap <leader>gs :G<CR>
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git pull<CR>

" For new branch
" gets branch name
" sets upstream origin automatically
function! GitPushUpsOrgBranch()
  let branch = system("git branch --show-current")
  let push_str = "git push --set-upstream origin ".branch
  let conf_msg = "Do you want to execute\n".push_str
  let push_str_out = system(push_str)
  echo push_str_out
  return 1
endfunction
nnoremap <leader>gu :call GitPushUpsOrgBranch()<CR>

" Git fzf
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 }}
let g:fzf_branch_actions = {
      \ 'track': {
      \   'keymap': 'ctrl-t',
      \ }
      \}
let $FZF_DEFAULT_OPTS='--reverse'
nnoremap <leader>gb :GBranches<CR>
