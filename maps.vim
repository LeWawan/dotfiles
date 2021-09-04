" Mapleader
let mapleader = " "

" Autocmd
autocmd BufWritePre * :%s/\s\+$//e

" Splits remaps
nnoremap <C-S> <C-W>s
nnoremap <C-V> <C-W>v

nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>

imap <C-c> <Esc>
