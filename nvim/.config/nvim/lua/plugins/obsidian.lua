return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
    },

    -- see below for full list of options 👇
    daily_notes = {
      folder = "☀️  Dailies/"
    },
    follow_url_func = function(url)
      local os_name = vim.loop.os_uname().sysname
      local os_release = vim.loop.os_uname().release
      if os_name == "Darwin" then
        -- macOS
        vim.fn.jobstart({"open", url})
      elseif os_name == "Windows" or os_release:find("WSL2") then
        -- Windows or WSL
        vim.cmd(':exec "!start ' .. url .. '"')
      else
        -- Linux or other
        vim.fn.jobstart({"xdg-open", url})
      end
    end,

    follow_img_func = function(img)
      local os_name = vim.loop.os_uname().sysname
      local os_release = vim.loop.os_uname().release
      if os_name == "Darwin" then
        -- macOS
        vim.fn.jobstart { "qlmanage", "-p", img }
      elseif os_name == "Windows" or os_release:find("WSL2") then
        -- Windows or WSL
        vim.cmd(':exec "!start ' .. img .. '"')
      else
        -- Linux or other
        vim.fn.jobstart({"xdg-open", img})
      end
    end,
  },
}
