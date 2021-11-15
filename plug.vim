if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

" Theme
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'

" Finders
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'ThePrimeagen/harpoon'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'

" Theme
Plug 'kyazdani42/nvim-web-devicons'


" Git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { ->  fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
" }}}

" https://github.com/mbbill/undotree
Plug 'mbbill/undotree'

" Lsp
"Plug 'neovim/nvim-lspconfig'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': 'TSUpdate' }

" Vsnip
"Plug 'hrsh7th/vim-vsnip'

" Completion
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
"Plug 'hrsh7th/vim-vsnip-integ'

" Auto LSP
"Plug 'prabirshrestha/vim-lsp'
"Plug 'mattn/vim-lsp-settings'

" Coc autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}


call plug#end()
