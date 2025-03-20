return {
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		lazy = true,
		opts = function()
			require("Comment").setup()
		end,
	},
}
