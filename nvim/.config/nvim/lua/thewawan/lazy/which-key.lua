return {
	"folke/which-key.nvim",
	eent = "VeryLazy",
	opts = {
		plugins = { spelling = true },
		defaults = {
			mode = { "n", "v" },
			["]"] = { name = "+next" },
			["["] = { name = "+prev" },

			["<leader>f"] = {
				name = "+telescope",
				{
					p = "Git files",
					f = "Find files",
					g = "Live grep",
					b = "Buffers",
					h = "Help tags",
					t = "Treesitter",
					["'"] = "< VimRC >",
				},
			},
			["<leader>g"] = { name = "+git", {
				b = "Git branches",
				s = "Git status",
			} },

			["<leader>w"] = { name = "+windows" },

			["<leader>x"] = {
				name = "+trouble",
				{
					x = "Toggle trouble",
					w = "Toggle trouble workspace",
					q = "Toggle quickfix",
					l = "Toggle loclist",
				},
			},

			-- Perso
			["<leader>t"] = {
				name = "+terminal",
				{
					h = "Toggle terminal 1",
					j = "Toggle terminal 2",
					k = "Toggle terminal 3",
					l = "Toggle terminal 4",
				},
			},
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register(opts.defaults)
	end,
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
}
