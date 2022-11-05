local Remap = require('thewawan.keymap')
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

-- Autocmd
vim.cmd("autocmd BufWritePre * :%s/\\s\\+$//e")

inoremap('<C-c>', '<Esc>')

-- Size remaps
nnoremap('<leader>-',  ':vertical resize -10<CR>')
nnoremap('<leader>+', ':vertical resize +10<CR>')

nnoremap('<leader><CR>', ':so ~/.dotfiles/.config/nvim/init.lua<CR>')
