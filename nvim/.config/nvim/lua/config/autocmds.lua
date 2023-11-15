-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Things

-- Format any blank spaces at the end of the line
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  callback = function()
    vim.cmd(":%s/\\s\\+$//e")
  end,
})

-- Format on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.go,*.ts,*.vue,*.astro",
  callback = function()
    vim.lsp.buf.format()
  end,
})
