local o = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = "\\"

-- o.guicursor = ''
o.mouse = nil

o.filetype = "on"

o.nu = true
o.relativenumber = true

o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.hlsearch = false
o.incsearch = true

o.wrap = false

o.swapfile = false
o.backup = false
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true

o.hlsearch = false
o.incsearch = true

o.termguicolors = true

o.scrolloff = 8
o.signcolumn = "yes"
o.isfname:append("@-@")

-- Give more space for displaying messages.
o.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
o.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
o.shortmess:append("c")

o.colorcolumn = "120"

if vim.fn.has("mac") == 1 then
	o.clipboard = "unnamedplus"
else
	g.clipboard = {
		name = "xsel",
		copy = {
			["+"] = "xsel --nodetach -i -b",
			["*"] = "xsel --nodetach -i -p",
		},
		paste = {
			["+"] = "xsel  -o -b",
			["*"] = "xsel  -o -b",
		},
		cache_enabled = 1,
	}
	o.clipboard = "unnamedplus"
end

-- g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_browse_split = 4
g.netrw_altv = 1
g.netrw_winsize = 15

-- disabled some providers...

g.loaded_node_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0


-- obsidian related settings

o.conceallevel = 1
