return {
	"tpope/vim-fugitive",
	event = "VeryLazy",
	lazy = true,
	config = function()
		-- Fzf
		vim.keymap.set("n", "<leader>gs", function()
			vim.cmd.Git()
		end)
		vim.keymap.set("n", "<leader>gf", "<cmd>diffget //2<CR>") -- Ours
		vim.keymap.set("n", "<leader>gj", "<cmd>diffget //3<CR>") -- Theirs
		vim.keymap.set("n", "<leader>gp", function()
			vim.cmd.Git("push")
		end)
		vim.keymap.set("n", "<leader>gl", function()
			vim.cmd.Git("pull")
		end)

		-- Push upstream for new branch
		local function gitPushUpsOrgBranch()
			local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
			vim.cmd("Git push --set-upstream origin " .. branch)
		end

		vim.keymap.set("n", "<leader>gu", function()
			gitPushUpsOrgBranch()
		end)
	end,
}
