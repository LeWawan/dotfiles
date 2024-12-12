return {
	{
		"folke/snacks.nvim",
		priority = 999,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = false },
			dashboard = {
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
					{ section = "startup" },
					{
						section = "terminal",
						cmd = "ascii-image-converter ~/.dotfiles/wall.png -C -c",
						random = 10,
						pane = 2,
						indent = 4,
						height = 30,
					},
				},
			},
			indent = { enabled = false },
			input = { enabled = false },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			quickfile = { enabled = false },
			scope = { enabled = false },
			scroll = { enabled = false },
			statuscolumn = { enabled = false },
			styles = {},
			words = { enabled = false },
		},
		keys = {
			-- {
			-- 	"<leader>z",
			-- 	function()
			-- 		Snacks.zen()
			-- 	end,
			-- 	desc = "Toggle Zen Mode",
			-- },
			-- {
			-- 	"<leader>Z",
			-- 	function()
			-- 		Snacks.zen.zoom()
			-- 	end,
			-- 	desc = "Toggle Zoom",
			-- },
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			-- {
			-- 	"<leader>S",
			-- 	function()
			-- 		Snacks.scratch.select()
			-- 	end,
			-- 	desc = "Select Scratch Buffer",
			-- },
			{
				"<leader>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			-- {
			-- 	"<leader>bd",
			-- 	function()
			-- 		Snacks.bufdelete()
			-- 	end,
			-- 	desc = "Delete Buffer",
			-- },
			-- {
			-- 	"<leader>cR",
			-- 	function()
			-- 		Snacks.rename.rename_file()
			-- 	end,
			-- 	desc = "Rename File",
			-- },
			{
				"<leader>gB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse",
			},
			-- {
			-- 	"<leader>gb",
			-- 	function()
			-- 		Snacks.git.blame_line()
			-- 	end,
			-- 	desc = "Git Blame Line",
			-- },
			-- {
			-- 	"<leader>gf",
			-- 	function()
			-- 		Snacks.lazygit.log_file()
			-- 	end,
			-- 	desc = "Lazygit Current File History",
			-- },
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			-- {
			-- 	"<leader>gl",
			-- 	function()
			-- 		Snacks.lazygit.log()
			-- 	end,
			-- 	desc = "Lazygit Log (cwd)",
			-- },
			-- {
			-- 	"<leader>un",
			-- 	function()
			-- 		Snacks.notifier.hide()
			-- 	end,
			-- 	desc = "Dismiss All Notifications",
			-- },
			-- {
			-- 	"<c-/>",
			-- 	function()
			-- 		Snacks.terminal()
			-- 	end,
			-- 	desc = "Toggle Terminal",
			-- },
			-- {
			-- 	"<c-_>",
			-- 	function()
			-- 		Snacks.terminal()
			-- 	end,
			-- 	desc = "which_key_ignore",
			-- },
			-- {
			-- 	"]]",
			-- 	function()
			-- 		Snacks.words.jump(vim.v.count1)
			-- 	end,
			-- 	desc = "Next Reference",
			-- 	mode = { "n", "t" },
			-- },
			-- {
			-- 	"[[",
			-- 	function()
			-- 		Snacks.words.jump(-vim.v.count1)
			-- 	end,
			-- 	desc = "Prev Reference",
			-- 	mode = { "n", "t" },
			-- },
			{
				"<leader>N",
				desc = "Neovim News",
				function()
					Snacks.win({
						file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							signcolumn = "yes",
							statuscolumn = " ",
							conceallevel = 3,
						},
					})
				end,
			},
		},
	},
}
