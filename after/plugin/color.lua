vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_transparent = true
vim.opt.background = 'dark'

vim.g.tokyonight_style = 'night'
vim.g.tokyonight_italic_functions = 1

vim.cmd("let g:lightline = {'colorscheme': 'tokyonight', 'active': {'left': [[ 'mode', 'paste', 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings', 'lsp_ok' ],[ 'gitbranch', 'readonly', 'relativepath', 'lsp_status', 'modified' ] ]}, 'component_function': { 'gitbranch': 'FugitiveHead' }} ")
vim.cmd("call lightline#lsp#register()")
vim.cmd('colorscheme tokyonight')


