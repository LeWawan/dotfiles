if !exists('g:loaded_nvim_treesitter')
  finish
endif

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "php",
    "json",
    "yaml",
    "vue",
    "html",
    "css",
    "scss",
    "javascript",
    "regex",
    "lua",
    "vim"
  }
}
EOF
