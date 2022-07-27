local Remap = require('thewawan.keymap')
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

nnoremap('<leader>pv', '<cmd>Ex<CR>')
inoremap('<C-c>', '<Esc>')
nnoremap('<leader><CR>', ':so ~/.config/nvim/init.lua<CR>')
