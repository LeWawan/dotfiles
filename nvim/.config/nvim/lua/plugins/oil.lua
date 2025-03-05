return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				columns = { "icon" },
				view_options = {
					show_hidden = true,
				},
			})

			vim.keymap.set("n", "<leader>m", function()
				require("oil").toggle_float("./")
				vim.cmd("setlocal relativenumber")
			end, { silent = true })

			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
}
