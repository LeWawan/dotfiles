return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				vue = { "prettier" },
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = "fallback",
			},
		})
	end,
}
