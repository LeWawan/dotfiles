local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Things
vim.cmd("autocmd BufWritePre * :%s/\\s\\+$//e")
-- vim.cmd("autocmd BufWritePre *.tsx,*.ts,*.js,*.html,*.css :Prettier")
vim.cmd("autocmd BufWritePre *.go,*.ts,*.vue,*.astro :lua vim.lsp.buf.format()")

-- Autocmd for astro
-- vim.cmd('autocmd BufNewFile,BufRead *.astro set filetype=astro')

keymap.set("n", "<C-c>", "<Esc>")
keymap.set("x", "<C-c>", "<Esc>")
keymap.set("i", "<C-c>", "<Esc>")

keymap.set("n", "<leader>db", ':%bdelete|edit #|normal`"<cr>')

-- Size remaps
keymap.set("n", "<leader>-", ":vertical resize -10<CR>")
keymap.set("n", "<leader>+", ":vertical resize +10<CR>")

keymap.set("n", "<leader><CR>", ":so ~/.dotfiles/nvim/.config/nvim/init.lua<CR>")

-- Move around (keep the cursor center)
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set("n", "n", "nzzzv")
keymap.set("n", "n", "nzzzv")

-- greatest remap ever (paste without override the registery)
keymap.set("x", "<leader>p", '"_dP')

-- next greatest remap ever : asbjornHaland
keymap.set("n", "<leader>y", '"+y')
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>Y", '"+Y', { noremap = false })

keymap.set("n", "<leader>d", '"_d')
keymap.set("v", "<leader>d", '"_d')

keymap.set("v", "<leader>d", '"_d')

keymap.set("n", "<leader><leader>x", ":so %<cr>")
keymap.set("n", "<leader><leader>z", ":LspRestart<cr>")

-- Fzf
keymap.set("n", "<leader>gs", ":G<CR>")
keymap.set("n", "<leader>gf", ":diffget //2<CR>") -- Ours
keymap.set("n", "<leader>gj", ":diffget //3<CR>") -- Theirs
keymap.set("n", "<leader>gp", ":Git push<CR>")
keymap.set("n", "<leader>gl", ":Git pull<CR>")

-- Push upstream for new branch
function GitPushUpsOrgBranch()
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
  vim.cmd("Git push --set-upstream origin " .. branch)
end

keymap.set("n", "<leader>gu", function()
  GitPushUpsOrgBranch()
end)

-- Harpoon
local mark = require("harpoon.mark")
local term = require("harpoon.term")
local ui = require("harpoon.ui")
local silent = { silent = true }

keymap.set("n", "<leader>q", function()
  mark.add_file()
end, silent)
keymap.set("n", "<leader>tc", function()
  require("harpoon.cmd-ui").toggle_quick_menu()
end, silent)

keymap.set("n", "<C-e>", function()
  ui.toggle_quick_menu()
end, silent)
keymap.set("n", "<C-h>", function()
  ui.nav_file(1)
end, silent)
keymap.set("n", "<C-j>", function()
  ui.nav_file(2)
end, silent)
keymap.set("n", "<C-k>", function()
  ui.nav_file(3)
end, silent)
keymap.set("n", "<C-l>", function()
  ui.nav_file(4)
end, silent)

keymap.set("n", "<leader>th", function()
  term.gotoTerminal(1)
end, silent)
keymap.set("n", "<leader>tj", function()
  term.gotoTerminal(2)
end, silent)
keymap.set("n", "<leader>tk", function()
  term.gotoTerminal(3)
end, silent)
keymap.set("n", "<leader>tl", function()
  term.gotoTerminal(4)
end, silent)

-- Undotree
keymap.set("n", "<F5>", ":UndotreeToggle<CR>")

-- Vim wiki
keymap.set("n", "<leader>,", ":VimwikiToggleListItem<CR>")
keymap.set("n", "<leader>ww", ":VimwikiIndex<CR>")

-- Clipboard
-- vim.cmd("let g:clipboard = { 'name': 'WslClipboard', 'copy': {    '+': 'clip.exe',    '*': 'clip.exe',  }, 'paste': {    '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',    '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))', }, 'cache_enabled': 0}")
