return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "css",
          "go",
          "vue",
          "yaml",
          "json",
          "html",
          "javascript",
          "typescript",
          "lua",
        },
        config = function(_, opts)
          require("plugins.treesitter.config").config(opts)

          -- MDX support
          vim.filetype.add({ extension = "mdx", type = "markdown" })
          vim.treesitter.language.register("markdown", "mdx")
        end,
      })
    end,
  },
  { "nvim-treesitter/playground" },
}
