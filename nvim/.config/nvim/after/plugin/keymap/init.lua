local Remap = require('thewawan.keymap')
local nmap = Remap.nmap
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local vnoremap = Remap.vnoremap

-- Autocmd
vim.cmd("autocmd BufWritePre * :%s/\\s\\+$//e")

inoremap('<C-c>', '<Esc>')

-- Size remaps
nnoremap('<leader>-',  ':vertical resize -10<CR>')
nnoremap('<leader>+', ':vertical resize +10<CR>')

nnoremap('<leader><CR>', ':so ~/.dotfiles/nvim/.config/nvim/init.lua<CR>')

-- Move around (keep the cursor center)
nnoremap('<C-d>', '<C-d>zz')
nnoremap('<C-u>', '<C-u>zz')

nnoremap('n', 'nzzzv')
nnoremap('n', 'nzzzv')

-- greatest remap ever (paste without override the registery)
xnoremap('<leader>p', "\"_dP")

-- next greatest remap ever : asbjornHaland
nnoremap("<leader>y", "\"+y")
vnoremap("<leader>y", "\"+y")
nmap("<leader>Y", "\"+Y")

nnoremap("<leader>d", "\"_d")
vnoremap("<leader>d", "\"_d")

vnoremap("<leader>d", "\"_d")
