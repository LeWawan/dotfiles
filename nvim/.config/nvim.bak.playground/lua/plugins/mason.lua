return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        --- Lua stuff
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",

        -- Bash/Shell
        "shfmt",

        -- FrontEnd Stuff
        "tailwindcss-language-server",
        "vue-language-server",
        "css-lsp",
      })
    end,
  },
}
