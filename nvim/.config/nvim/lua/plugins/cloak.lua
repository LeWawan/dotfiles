return {
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
}
