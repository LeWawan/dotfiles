return {

	-- The primeagen you said ?
	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
		lazy = true,
		config = function()
			local mark = require("harpoon.mark")
			local term = require("harpoon.term")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>q", function()
				mark.add_file()
			end, { silent = true })
			vim.keymap.set("n", "<C-e>", function()
				ui.toggle_quick_menu()
			end, { silent = true })

			vim.keymap.set("n", "<C-h>", function()
				ui.nav_file(1)
			end, { silent = true })
			vim.keymap.set("n", "<C-j>", function()
				ui.nav_file(2)
			end, { silent = true })
			vim.keymap.set("n", "<C-k>", function()
				ui.nav_file(3)
			end, { silent = true })
			vim.keymap.set("n", "<C-l>", function()
				ui.nav_file(4)
			end, { silent = true })

			vim.keymap.set("n", "<leader>th", function()
				term.gotoTerminal(1)
			end, { silent = true })
			vim.keymap.set("n", "<leader>tj", function()
				term.gotoTerminal(2)
			end, { silent = true })
			vim.keymap.set("n", "<leader>tk", function()
				term.gotoTerminal(3)
			end, { silent = true })
			vim.keymap.set("n", "<leader>tl", function()
				term.gotoTerminal(4)
			end, { silent = true })
		end,
	},
	{
		"ThePrimeagen/vim-be-good",
		event = "VeryLazy",
		lazy = true,
	},

	{
		"smjonas/inc-rename.nvim",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("inc_rename").setup()
			vim.keymap.set("n", "<leader>rn", ":IncRename ")
		end,
	},

	{
		"laytan/cloak.nvim",
		event = "VeryLazy",
		lazy = true,
		config = function()
			local cloak = require("cloak")
			cloak.setup()

			vim.keymap.set("n", "<leader>xx", function()
				cloak.toggle()
			end)
		end,
	},

	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		lazy = true,
	},
}
