return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local telescope = require("telescope.builtin")
			local trouble = require("trouble.providers.telescope")

			vim.keymap.set("n", "<leader>fp", function()
				telescope.git_files()
			end)
			vim.keymap.set("n", "<leader>ff", function()
				telescope.find_files({ hidden = true })
			end)
			vim.keymap.set("n", "<leader>fg", function()
				telescope.live_grep({ hidden = true })
			end)
			vim.keymap.set("n", "<leader>fr", function()
				telescope.lsp_references()
			end)
			vim.keymap.set("n", "<leader>ft", function()
				telescope.treesitter()
			end)
			vim.keymap.set("n", "<leader>fb", function()
				telescope.buffers()
			end)
			vim.keymap.set("n", "<leader>fh", function()
				telescope.help_tags()
			end)
			vim.keymap.set("n", "<leader>gb", function()
				telescope.git_branches({
					show_remote_tracking_branches = false,
				})
			end)
			vim.keymap.set("n", "<leader>'", function()
				telescope.git_files({ prompt_title = "< VimRC >", cwd = "~/.dotfiles/", hidden = false })
			end)
			vim.keymap.set("n", "<leader>vh", function()
				telescope.help_tags()
			end)

			-- Lsp keymaps
			vim.keymap.set("n", "<leader>gd", function()
				telescope.lsp_definitions()
			end)
			vim.keymap.set("n", "<leader>gi", function()
				telescope.lsp_implementations()
			end)
			vim.keymap.set("n", "<leader>gr", function()
				telescope.lsp_references()
			end)

			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-q>"] = trouble.open_with_trouble,
							["<C-t>"] = trouble.open_with_trouble,
						},
						n = {
							["<C-q>"] = trouble.open_with_trouble,
							["<C-t>"] = trouble.open_with_trouble,
						},
					},
				},
			})
		end,
	},
}
