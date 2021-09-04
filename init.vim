" Basics "{{{
" ----------------------------------------------------------------
" init autocmd
autocmd!
" set config encoding
set encoding=utf-8
" stop loading confg if it's on typy  or small
if !1 | finish | endif
" source the .vimrc in the dir you launch vim .
set exrc

set clipboard=unnamed

set nocompatible
set number
set relativenumber
syntax enable
set autoread
set nu
set nohlsearch
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartcase
set ignorecase
set nowrap
set noswapfile
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set cmdheight=2
set colorcolumn=180
set signcolumn=yes
highlight ColorColumn ctermbg=0 guibg=lightgrey
set termguicolors
set iskeyword+=-
set noshowmode

" Imports "{{{
" ---------------------------------------------------------------------
runtime ./plug.vim
if has("unix")
  let s:uname = system("uname -s")
  " Do Mac stuff
  if s:uname == "Darwin\n"
    runtime ./macos.vim
  endif
endif

runtime ./maps.vim

runtime ./theme.vim
"}}}

" Lua import
lua require('thewawan')

