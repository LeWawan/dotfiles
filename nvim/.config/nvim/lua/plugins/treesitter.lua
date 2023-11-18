return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "astro",
        "cmake",
        "css",
        "go",
        "http",
        "rust",
        "vue",
        "sql",
        "php",
        "python",
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
    },
  },
}
