syntax on

set encoding=UTF-8
set guifont=DroidSansMono\ Nerd\ Font:h11

set clipboard=unnamed

set autoread
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
set colorcolumn=180
set signcolumn=yes
highlight ColorColumn ctermbg=0 guibg=lightgrey
set nocompatible
set termguicolors
set iskeyword+=-
set noshowmode

let mapleader = " "

" Autocmd
autocmd BufWritePre * :%s/\s\+$//e

" Functions
noremap <leader>zz :CloseHiddenBuffers<CR>

function! s:CloseHiddenBuffers()
  let open_buffers = []

  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor

  for num in range(1, bufnr("$") + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec "bdelete ".num
    endif
  endfor
endfunction

nnoremap <C-S> <C-W>s
nnoremap <C-V> <C-W>v

nnoremap <leader>ww !open '%'<cr>

call plug#begin('~/.vim/plugged')

" UndoTree
Plug 'mbbill/undotree'

" NerdTree
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'

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

" LSP Baby
"Plug 'neovim/nvim-lspconfig'
"Plug 'nvim-lua/completion-nvim'

" Emmet
"Plug 'mattn/emmet-vim'

" DevIcons
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

" Git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { ->  fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

" ThePrimeagen
Plug 'ThePrimeagen/vim-be-good'

Plug 'ThePrimeagen/git-worktree.nvim'

" Wiki
Plug 'vimwiki/vimwiki'

" Svelte
Plug 'leafOfTree/vim-svelte-plugin'

" Icons && Syntax highlight for NerdTree
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'


call plug#end()

let g:vim_svelte_plugin_use_typescript = 1


lua require('thewawan')

