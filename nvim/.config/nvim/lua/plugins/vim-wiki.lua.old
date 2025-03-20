return {
	"vimwiki/vimwiki",
	event = "VeryLazy",
	lazy = true,
	config = function()
		vim.g.vimwiki_list = {
			{
				path = "~/vimwiki",
				syntax = "markdown",
				ext = ".md",
			},
		}
		vim.g.vimwiki_ext2syntax = {
			[".md"] = "markdown",
			[".markdown"] = "markdown",
			[".mdown"] = "markdown",
		}
	end,
}
