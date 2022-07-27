local nnoremap = require('thewawan.keymap').nnoremap

local silent = { silent = true }

-- Terminal commands
-- ueoa is first through fourth finger left hand home row.
-- This just means I can crush, with opposite hand, the 4 terminal positions
--
-- These functions are stored in harpoon.  A plugn that I am developing
nnoremap("<leader>q", function() require("harpoon.mark").add_file() end, silent)
nnoremap("<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, silent)
nnoremap("<leader>tc", function() require("harpoon.cmd-ui").toggle_quick_menu() end, silent)

nnoremap("<C-h>", function() require("harpoon.ui").nav_file(1) end, silent)
nnoremap("<C-j>", function() require("harpoon.ui").nav_file(2) end, silent)
nnoremap("<C-k>", function() require("harpoon.ui").nav_file(3) end, silent)
nnoremap("<C-l>", function() require("harpoon.ui").nav_file(4) end, silent)

nnoremap("<leader>th", function() require("harpoon.term").gotoTerminal(1) end, silent)
nnoremap("<leader>tj", function() require("harpoon.term").gotoTerminal(2) end, silent)
nnoremap("<leader>tk", function() require("harpoon.term").gotoTerminal(3) end, silent)
nnoremap("<leader>tl", function() require("harpoon.term").gotoTerminal(4) end, silent)
