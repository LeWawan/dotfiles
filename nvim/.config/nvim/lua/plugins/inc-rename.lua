return {
	{
		"smjonas/inc-rename.nvim",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("inc_rename").setup()
			vim.keymap.set("n", "<leader>rn", ":IncRename ")
		end,
	},
}
