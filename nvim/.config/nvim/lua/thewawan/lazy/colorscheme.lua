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
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end
  },
}
