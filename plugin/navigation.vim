" Vim LSP Remaps
nnoremap <C-q> :copen<CR>
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprev<CR>

nnoremap <C-q> :call ToggleQFList(1)<CR>

let g:the_wawan_qf_l = 0
let g:the_wawan_qf_g = 0
let g:the_wawan_qf = 0

fun! ToggleQFList(global)
    if g:the_wawan_qf == 1
        let g:the_wawan_qf = 0
        if a:global
            let g:the_wawan_qf_g = 0
            cclose
        else
            let g:the_wawan_qf_l = 0
            lclose
        endif
    else
        let g:the_wawan_qf = 1
        if a:global
            let g:the_wawan_qf_g = 0
            copen
        else
            let g:the_wawan_qf_l = 0
            lopen
        endif
    endif
endfun


