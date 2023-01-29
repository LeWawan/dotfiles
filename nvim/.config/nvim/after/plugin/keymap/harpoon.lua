local mark = require('harpoon.mark')
local term = require('harpoon.term')
local ui = require('harpoon.ui')

local nnoremap = require('thewawan.keymap').nnoremap

local silent = { silent = true }

-- Terminal commands
nnoremap("<leader>q", function() mark.add_file() end, silent)
nnoremap("<leader>tc", function() require("harpoon.cmd-ui").toggle_quick_menu() end, silent)

nnoremap("<C-e>", function() ui.toggle_quick_menu() end, silent)
nnoremap("<C-h>", function() ui.nav_file(1) end, silent)
nnoremap("<C-j>", function() ui.nav_file(2) end, silent)
nnoremap("<C-k>", function() ui.nav_file(3) end, silent)
nnoremap("<C-l>", function() ui.nav_file(4) end, silent)

nnoremap("<leader>th", function() term.gotoTerminal(1) end, silent)
nnoremap("<leader>tj", function() term.gotoTerminal(2) end, silent)
nnoremap("<leader>tk", function() term.gotoTerminal(3) end, silent)
nnoremap("<leader>tl", function() term.gotoTerminal(4) end, silent)
