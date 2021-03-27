syntax on

set encoding=utf-8

set clipboard=unnamed

set exrc "This line source the .vimrc in the dir you launch vim .
set relativenumber
set nu
set nohlsearch
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
"set smartindent
set smartcase
set ignorecase
set nowrap
set noswapfile
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set cmdheight=2
set colorcolumn=80
set signcolumn=yes
highlight ColorColumn ctermbg=0 guibg=lightgrey
set nocompatible
set termguicolors
set iskeyword+=-
set noshowmode

let mapleader = " "

" Autocmd
autocmd BufWritePre * :%s/\s\+$//e

" UNdotree
nnoremap <F5> :UndotreeToggle<CR>

" NERDTree
nnoremap <leader>n :NERDTreeToggle %<CR>
let g:NERDTreeGitStatusWithFlags = 1
let g:NERDTreeIgnore = ['^node_modules$']

" Custom
nnoremap <leader>sc :!unison-2.48 -sshargs '-C'  -prefer newer  -confirmbigdel  -ignorecase false  -ignore 'Path private/symfony4/var'  -ignore 'Path logs_apache'  -ignore 'Path */*/node_modules'  -ignore 'Path private/vendor'  -ignore 'Path logs_appli'  -batch '/Users/mbp13-montagnes/Lab/erwan' ssh://www-data@solaroc.compilatio.net//home/sites/erwan<CR>

nnoremap <C-S> <C-W>s
nnoremap <C-V> <C-W>v

" Vim LSP Remaps
nnoremap <C-Q> :copen<CR>
nnoremap <C-J> :cnext<CR>
nnoremap <C-K> :cprev<CR>

" Telescope conf baby...
"lua << EOF
    "require('telescope').load_extension('fzy_native')
"EOF
nnoremap <Leader>p <cmd>lua require'telescope.builtin'.git_files{}<CR>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>ft <cmd>lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').git_status()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>' <cmd> lua require("telescope.builtin").find_files({ prompt_title = "< VimRC >", cwd = "$HOME/dotfiles/TheWawan/"})<cr>

" Vim-fugitive
nnoremap <leader>gs :G<CR>
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git pull<CR>

" CocConfig
set updatetime=300
set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)


call plug#begin('~/.vim/plugged')

" UndoTree
Plug 'mbbill/undotree'

" NerdTree
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'ryanoasis/vim-devicons'

" ColorScheme => Call it after plugin section
"Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'

" Lightline statusbar
Plug 'itchyny/lightline.vim'

" Telescope baby !!!!
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Coc Vim for autocompletions
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Git
Plug 'tpope/vim-fugitive'

call plug#end()

lua require('thewawan')

colorscheme gruvbox
set background=dark
highlight Normal guibg=none
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ }

