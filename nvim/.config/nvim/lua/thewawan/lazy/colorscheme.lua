return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    config = function()
      vim.cmd([[colorscheme solarized-osaka]])
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = function ()
      require("lualine").setup({
        options = {
          theme = "solarized-osaka",
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "filename",
              path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
              filetype_names = {
                TelescopePrompt = 'Telescope',
                dashboard = 'Dashboard',
                packer = 'Packer',
                fzf = 'FZF',
                alpha = 'Alpha'
              },
            },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end
  },
}
