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

" Custom
nnoremap <leader>sc :!unison-2.48 -sshargs '-C'  -prefer newer  -confirmbigdel  -ignorecase false  -ignore 'Path private/symfony4/var'  -ignore 'Path logs_apache'  -ignore 'Path */*/node_modules'  -ignore 'Path private/vendor'  -ignore 'Path logs_appli'  -batch '/Users/mbp13-montagnes/Lab/erwan' ssh://www-data@solaroc.compilatio.net//home/sites/erwan<CR>

nnoremap <C-S> <C-W>s
nnoremap <C-V> <C-W>v

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
Plug 'junegunn/fzf', { 'do': { ->  fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

call plug#end()

lua require('thewawan')

