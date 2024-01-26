return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	config = function()
		local banned_messages = { "No information available" }
		vim.notify = function(msg, ...)
			for _, banned in ipairs(banned_messages) do
				if msg == banned then
					return
				end
			end
			return require("notify")(msg, ...)
		end
	end,
}
