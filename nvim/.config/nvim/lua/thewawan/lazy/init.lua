return {
  "mbbill/undotree",
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          width = 120,
          options = {
            number = true,
            relativenumber = true,
          },
        },
      })

      vim.keymap.set("n", "<leader>zz", function()
        require("zen-mode").toggle()
        vim.wo.wrap = false
      end)
    end,
  },

  -- The primeagen you said ?
  {
    "ThePrimeagen/harpoon",
    config = function()
      local mark = require("harpoon.mark")
      local term = require("harpoon.term")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>q", function() mark.add_file() end, { silent = true })
      vim.keymap.set("n", "<C-e>", function() ui.toggle_quick_menu() end, { silent = true })

      vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, { silent = true })
      vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end, { silent = true })
      vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end, { silent = true })
      vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end, { silent = true })

      vim.keymap.set("n", "<leader>th", function() term.gotoTerminal(1) end, { silent = true })
      vim.keymap.set("n", "<leader>tj", function() term.gotoTerminal(2) end, { silent = true })
      vim.keymap.set("n", "<leader>tk", function() term.gotoTerminal(3) end, { silent = true })
      vim.keymap.set("n", "<leader>tl", function() term.gotoTerminal(4) end, { silent = true })
    end
  },
  "ThePrimeagen/vim-be-good",

  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "<leader>rn", ":IncRename ")
    end,
  },

  "github/copilot.vim",
  {
    "laytan/cloak.nvim",
    config = function()
      require("cloak").setup()
    end
  },

  {
      'numToStr/Comment.nvim',
      opts = {
          -- add any options here
      },
      lazy = false,
  },
}
