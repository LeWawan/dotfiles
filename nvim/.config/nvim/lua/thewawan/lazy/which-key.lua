return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		plugins = { spelling = true },
		defaults = {
			-- mode = { "n", "v" },
			-- ["]"] = { name = "+next" },
			-- ["["] = { name = "+prev" },
			--
			-- ["<leader>f"] = {
			-- 	name = "+telescope",
			-- 	{
			-- 		p = "Git files",
			-- 		f = "Find files",
			-- 		g = "Live grep",
			-- 		b = "Buffers",
			-- 		h = "Help tags",
			-- 		t = "Treesitter",
			-- 		["'"] = "< VimRC >",
			-- 	},
			-- },
			-- ["<leader>g"] = { name = "+git", {
			-- 	b = "Git branches",
			-- 	s = "Git status",
			-- } },
			--
			-- ["<leader>w"] = { name = "+windows" },
			--
			-- ["<leader>x"] = {
			-- 	name = "+trouble",
			-- 	{
			-- 		x = "Toggle trouble",
			-- 		w = "Toggle trouble workspace",
			-- 		q = "Toggle quickfix",
			-- 		l = "Toggle loclist",
			-- 	},
			-- },
			--
			-- -- Perso
			-- ["<leader>t"] = {
			-- 	name = "+terminal",
			-- 	{
			-- 		h = "Toggle terminal 1",
			-- 		j = "Toggle terminal 2",
			-- 		k = "Toggle terminal 3",
			-- 		l = "Toggle terminal 4",
			-- 	},
			-- },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- mode = { "n", "v" },
		-- ["]"] = { name = "+next" },
		-- ["["] = { name = "+prev" },
		--
		-- ["<leader>f"] = {
		-- 	name = "+telescope",
		-- 	{
		-- 		p = "Git files",
		-- 		f = "Find files",
		-- 		g = "Live grep",
		-- 		b = "Buffers",
		-- 		h = "Help tags",
		-- 		t = "Treesitter",
		-- 		["'"] = "< VimRC >",
		-- 	},
		-- },
		-- ["<leader>g"] = { name = "+git", {
		-- 	b = "Git branches",
		-- 	s = "Git status",
		-- } },
		--
		-- ["<leader>w"] = { name = "+windows" },
		--
		-- ["<leader>x"] = {
		-- 	name = "+trouble",
		-- 	{
		-- 		x = "Toggle trouble",
		-- 		w = "Toggle trouble workspace",
		-- 		q = "Toggle quickfix",
		-- 		l = "Toggle loclist",
		-- 	},
		-- },
		--
		-- -- Perso
		-- ["<leader>t"] = {
		-- 	name = "+terminal",
		-- 	{
		-- 		h = "Toggle terminal 1",
		-- 		j = "Toggle terminal 2",
		-- 		k = "Toggle terminal 3",
		-- 		l = "Toggle terminal 4",
		-- 	},
		-- },
		--
		wk.add({
			{ "]", "+next", desc = "Next error" },
			{ "[", "+prev", desc = "Previous error" },

			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[Telescope] Find file", mode = "n" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "[Telescope] Live grep", mode = "n" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "[Telescope] Buffers", mode = "n" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "[Telescope] Help tags", mode = "n" },
			{ "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "[Telescope] Treesitter", mode = "n" },
			{
				"<leader>f'",
				"<cmd>Telescope find_files cwd=~/.config/nvim<cr>",
				desc = "[Telescope] VimRC",
				mode = "n",
			},

			{ "<leader>gb", desc = "[Fugitive] Git branches", mode = "n" },
			{ "<leader>gs", desc = "[Fugitive] Git status", mode = "n" },

			{ "<leader>xt", desc = "[Trouble] Toggle trouble", mode = "n" },
			{ "<leader>xw", desc = "[Trouble] Toggle trouble workspace", mode = "n" },
			{ "<leader>xq", desc = "[Trouble] Toggle quickfix", mode = "n" },
			{ "<leader>xl", desc = "[Trouble] Toggle loclist", mode = "n" },

			{ "<leader>th", desc = "[Terminal] Toggle terminal 1", mode = "n" },
			{ "<leader>tj", desc = "[Terminal] Toggle terminal 2", mode = "n" },
			{ "<leader>tk", desc = "[Terminal] Toggle terminal 3", mode = "n" },
			{ "<leader>tl", desc = "[Terminal] Toggle terminal 4", mode = "n" },
		})

		wk.add(opts.defaults)
	end,
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
}
