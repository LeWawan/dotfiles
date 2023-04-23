vim.opt.background = 'dark'

require("tokyonight").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  transparent = true, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = { italic = true },
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "transparent", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "packer", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  -- on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  -- on_highlights = function(highlights, colors) end,
})

vim.cmd("let g:lightline = {'colorscheme': 'tokyonight', 'active': {'left': [[ 'mode', 'paste', 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings', 'lsp_ok' ],[ 'gitbranch', 'readonly', 'relativepath', 'lsp_status', 'modified' ] ]}, 'component_function': { 'gitbranch': 'FugitiveHead' }} ")
vim.cmd("call lightline#lsp#register()")

vim.cmd('colorscheme tokyonight-storm')






-- require('everblush').setup({
--
--     -- Default options
--     override = {},
--
--     -- Set transparent background
--     transparent_background = false,
--     -- transparent_background = true,
--
--     -- Set contrast for nvim-tree highlights
--     nvim_tree = {
--         contrast = false,
--     },
--     -- nvim_tree = {
--     --     contrast = true,
--     -- },
--
--
--
--   styles = {
--     -- Style to be applied to different syntax groups
--     -- Value is any valid attr-list value for `:help nvim_set_hl`
--     comments = { italic = true },
--     keywords = { italic = true },
--     functions = { italic = true },
--     variables = {},
--     -- Background styles. Can be "dark", "transparent" or "normal"
--     sidebars = "transparent", -- style for sidebars, see below
--     floats = "dark", -- style for floating windows
--   },
--
-- })
--
-- vim.cmd("let g:lightline = {'colorscheme': 'everblush', 'active': {'left': [[ 'mode', 'paste', 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings', 'lsp_ok' ],[ 'gitbranch', 'readonly', 'relativepath', 'lsp_status', 'modified' ] ]}, 'component_function': { 'gitbranch': 'FugitiveHead' }} ")
-- vim.cmd("call lightline#lsp#register()")
-- vim.cmd('colorscheme everblush')


