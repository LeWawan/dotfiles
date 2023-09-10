vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Theming
  use 'folke/tokyonight.nvim'

  -- New theme ?
  use 'Everblush/nvim'

  use 'itchyny/lightline.vim'
  use 'josa42/nvim-lightline-lsp'
  use "lukas-reineke/indent-blankline.nvim"

  -- Sidebar
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzy-native.nvim' },
      { 'ThePrimeagen/git-worktree.nvim' },
      { 'ThePrimeagen/harpoon' }
    }
  }

  -- Autocompletion + Syntax highlight
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-treesitter/playground'

  -- Twoslash queries
  use 'marilari88/twoslash-queries.nvim'

  -- cmp
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'onsails/lspkind.nvim'

  -- vsnip
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  -- prettier
  use ({
    'prettier/vim-prettier',
    run = 'npm install --frozen-lockfile --production'
  })


  -- neodev.vim
  -- @note Potential breaking change...
  use "folke/neodev.nvim"

  -- Comment
  -- @see https://github.com/numToStr/Comment.nvim
  use 'numToStr/Comment.nvim'

  -- Git
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'

  -- Undotree
  use 'mbbill/undotree'

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

  -- Markdown
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- Start screen
  use 'mhinz/vim-startify'

  -- copilot
  use 'github/copilot.vim'

  -- import costs
  -- use 'barrett-ruth/import-cost.nvim'
  use({
    'yardnsm/vim-import-cost',
    run = 'npm install --omit=dev'
  })

  -- hex colors
  use 'norcalli/nvim-colorizer.lua'

  --
  use 'prisma/vim-prisma'

end)
