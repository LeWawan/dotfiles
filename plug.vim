if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

" Trees Undo/Nerd
Plug 'mbbill/undotree'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'

" Theming
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'

" Icons && Syntax highlight for NerdTree
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Telescope baby !!!!
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Harpoon
Plug 'ThePrimeagen/harpoon'



if has('nvim')
  " LSP Baby
  "Plug 'neovim/nvim-lspconfig'
  "Plug 'glepnir/lspsaga.nvim'
  Plug 'hrsh7th/vim-vsnip'
  " Install vim-cmp
  "Plug 'hrsh7th/nvim-cmp'
  " Install the buffer completion source
  "Plug 'hrsh7th/cmp-buffer'

  " Coc Config
  Plug 'neoclide/coc.nvim', {'branch': 'release'}


  " Emmet
  Plug 'mattn/emmet-vim'

  " TreeSitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  Plug 'nvim-treesitter/nvim-treesitter-refactor'

  " lua
  Plug 'nvim-lua/completion-nvim'
end

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

" Firestore
Plug 'delphinus/vim-firestore'


call plug#end()
