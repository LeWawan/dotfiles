return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
			},
		},
		config = function()
			local telescope = require("telescope.builtin")
			-- local trouble = require("trouble.providers.telescope")

			vim.keymap.set("n", "<leader>fp", function()
				telescope.git_files()
			end)
			vim.keymap.set("n", "<leader>ff", function()
				telescope.find_files({ hidden = true })
			end)
			vim.keymap.set("n", "<leader>fg", function()
				telescope.live_grep({ hidden = true })
			end)
			vim.keymap.set("n", "<leader>fc", function()
				require("telescope.builtin").live_grep({
					default_text = 'class="[^"]*<cursor>[^"]*"',
				})
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
					-- show_remote_tracking_branches = false,
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

			-- You dont need to set any of these options. These are the default ones. Only
			-- the loading is important
			require("telescope").setup({
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
				},
			})
			-- To get fzf loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("fzf")
		end,
	},
}
