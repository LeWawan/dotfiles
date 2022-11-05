vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Theming
  use 'folke/tokyonight.nvim'
  use 'itchyny/lightline.vim'
  use 'josa42/nvim-lightline-lsp'

  -- Finders
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use 'ThePrimeagen/git-worktree.nvim'
  use 'ThePrimeagen/harpoon'

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  --The best one => ThePrimeagen
  use "ThePrimeagen/vim-be-good"

  -- Git
  use 'tpope/vim-fugitive'
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install()'](0) end }
  use 'stsewd/fzf-checkout.vim'
  use 'airblade/vim-gitgutter'

  -- https://github.com/mbbill/undotree
  use 'mbbill/undotree'

  -- Lsp
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'onsails/lspkind-nvim'
  -- Auto install lsp
  use { "williamboman/mason.nvim" }

  -- Debugger
  use 'mfussenegger/nvim-dap'

  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-context'

  -- Emmet
  use 'mattn/emmet-vim'

  -- Wiki
  use {
    'vimwiki/vimwiki',
    config = function()
      vim.g.vimwiki_list = {
        {
          path = '~/vimwiki',
          syntax = 'markdown',
          ext  = '.md',
        }
      }
      vim.g.vimwiki_ext2syntax = {
        ['.md'] = 'markdown',
        ['.markdown'] = 'markdown',
        ['.mdown'] = 'markdown',
      }
    end
  }

  -- Completion
  --use 'ms-jpq/coq_nvim', {'branch': 'coq'}
  --use 'hrsh7th/vim-vsnip-integ'

  -- Auto LSP
  --use 'prabirshrestha/vim-lsp'
  --use 'mattn/vim-lsp-settings'

  -- Coc autocomplete
  -- use {'neoclide/coc.nvim', branch = 'release'}


  -- Extra plugin
  -- Solidity
  use 'tomlion/vim-solidity'

  -- Comment
  -- @see https://github.com/numToStr/Comment.nvim
  use 'numToStr/Comment.nvim'


  -- Nvim cmp
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- For vsnip users.
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  -- Tree
  -- requires
  use 'preservim/nerdtree'
  use 'kyazdani42/nvim-web-devicons' -- for file icons
  --use 'kyazdani42/nvim-tree.lua'

  -- Start screen
  use 'mhinz/vim-startify'

  -- Vue
  --use 'posva/vim-vue'

  -- Graphql
  use 'jparise/vim-graphql'

end)
