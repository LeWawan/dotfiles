" Theme
colorscheme gruvbox

set background=dark

highlight Normal guibg=none

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'cocstatus': 'coc#status',
      \ },
      \ }

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

