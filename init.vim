"  Basics "{{{
"  -------------------------------------------------------------
"  init autocmd
syntax enable

set encoding=utf-8
set colorcolumn=180
set signcolumn=yes
set termguicolors
set noshowmode

" ??????
"highlight ColorColumn ctermbg=0 guibg=lightgrey
"set highlight

" stop loading the config if an error occured
if !1 | finish | endif

" source the .vimrc in tyhe dir where we launch vim
set exrc

" ??????
set nocompatible

set number
set relativenumber

set autoread

set nohlsearch
set smartcase
set incsearch

set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set nowrap
set scrolloff=8

set noswapfile
set undofile
set undodir=~/.vim/undodir

set iskeyword+=-
" }}}

" Imports "{{{
"  -------------------------------------------------------------
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
" }}}

" Require more time to test
lua require('thewawan')
