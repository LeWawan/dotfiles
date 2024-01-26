return {
	"folke/trouble.nvim",
	config = function()
		local trouble = require("trouble")

		trouble.setup({
			icons = false,
		})

		-- Trouble default keymaps
		vim.keymap.set("n", "<leader>xx", function()
			trouble.toggle()
		end)
		vim.keymap.set("n", "<leader>xw", function()
			trouble.toggle("workspace_diagnostics")
		end)
		vim.keymap.set("n", "<leader>xd", function()
			trouble.toggle("document_diagnostics")
		end)
		vim.keymap.set("n", "<leader>xq", function()
			trouble.toggle("quickfix")
		end)
		vim.keymap.set("n", "<leader>xl", function()
			trouble.toggle("loclist")
		end)
		vim.keymap.set("n", "gR", function()
			trouble.toggle("lsp_references")
		end)

		-- Personal keymaps
		vim.keymap.set("n", "<C-q>", function()
			trouble.toggle()
		end)
		-- vim.keymap.set("n", "]d", function()
		-- 	if not trouble.is_open() then
		-- 		trouble.open({ mode = "document_diagnostics", skip_groups = true, jump = true })
		-- 	end
		-- 	trouble.next({ skip_groups = true, jump = true })
		-- end)
		-- vim.keymap.set("n", "[d", function()
		-- 	if not trouble.is_open() then
		-- 		trouble.open({ mode = "document_diagnostics", skip_groups = true, jump = true })
		-- 	end
		-- 	trouble.previous({ skip_groups = true, jump = true })
		-- end)
		vim.keymap.set("n", "<C-n>", function()
			trouble.next({ skip_groups = true, jump = true })
		end)
		vim.keymap.set("n", "<C-p>", function()
			trouble.previous({ skip_groups = true, jump = true })
		end)
	end,
}
