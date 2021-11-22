if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

" Theme
"Plug 'morhetz/gruvbox'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'itchyny/lightline.vim'

" Finders
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'ThePrimeagen/harpoon'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { ->  fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
" }}}

" https://github.com/mbbill/undotree
Plug 'mbbill/undotree'

" Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': 'TSUpdate' }

" Vsnip
Plug 'hrsh7th/vim-vsnip'

" Emmet
Plug 'mattn/emmet-vim'

" Completion
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
"Plug 'hrsh7th/vim-vsnip-integ'

" Auto LSP
"Plug 'prabirshrestha/vim-lsp'
"Plug 'mattn/vim-lsp-settings'

" Coc autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Nvim cmp
"Plug 'hrsh7th/cmp-nvim-lsp'
"Plug 'hrsh7th/cmp-buffer'
"Plug 'hrsh7th/cmp-path'
"Plug 'hrsh7th/cmp-cmdline'
"Plug 'hrsh7th/nvim-cmp'

" For vsnip users.
"Plug 'hrsh7th/cmp-vsnip'
"Plug 'hrsh7th/vim-vsnip'

" Tree
" requires
Plug 'preservim/nerdtree'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
"Plug 'kyazdani42/nvim-tree.lua'

" Start screen
Plug 'mhinz/vim-startify'

call plug#end()
