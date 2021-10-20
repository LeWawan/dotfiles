" Mapleader
let mapleader = " "

" Autocmd
autocmd BufWritePre * :%s/\s\+$//e

" Remember folds
augroup remember_folds
  autocmd!
  autocmd BufWritePre * mkview
  autocmd BufWinEnter * silent! loadview
augroup END

" Splits remaps
nnoremap <C-S> <C-W>s
nnoremap <C-V> <C-W>v

" Resize remaps
nnoremap <silent> <Leader>+ :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

" Change the workdir to the current dir
nnoremap <leader>cd :cd %:p:h<CR>

nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>

imap <C-c> <Esc>

