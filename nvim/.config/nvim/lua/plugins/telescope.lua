return {
  { "nvim-telescope/telescope-fzy-native.nvim" },
  { "ThePrimeagen/git-worktree.nvim" },
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("git_worktree")
      end,
    },
    opts = {
      defaults = {
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        color_devicons = true,

        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

        file_ignore_patterns = { "^%.git/", "^node_modules" },
        mappings = {
          i = { ["<c-q>"] = require("trouble.providers.telescope").open_with_trouble },
          n = { ["<c-q>"] = require("trouble.providers.telescope").open_with_trouble },
        },
      },
      pickers = {
        previewers = false,
      },
      extensions = {
        fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
        },
      },
    },
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").git_files()
        end,
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ hidden = true })
        end,
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({ hidden = true })
        end,
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").lsp_references()
        end,
      },
      {
        "<leader>ft",
        function()
          require("telescope.builtin").treesitter()
        end,
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
      },
      {
        "<leader>gb",
        function()
          require("telescope.builtin").git_branches()
        end,
      },
      {
        "<leader>'",
        function()
          require("telescope.builtin").find_files({ prompt_title = "< VimRC >", cwd = "~/.dotfiles/", hidden = true })
        end,
      },
      {
        "<leader>gw",
        function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end,
      },
      {
        "<leader>gm",
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end,
      },
      {
        "<leader>vh",
        function()
          require("telescope.builtin").help_tags()
        end,
      },
    },
  },
}
