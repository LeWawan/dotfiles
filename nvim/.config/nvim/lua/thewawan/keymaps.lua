-- Things
vim.cmd("autocmd BufWritePre * :%s/\\s\\+$//e")
-- vim.cmd("autocmd BufWritePre *.tsx,*.ts,*.js,*.html,*.css :Prettier")
vim.cmd("autocmd BufWritePre *.go,*.ts,*.vue :lua vim.lsp.buf.format()")

-- Autocmd for astro
vim.cmd('autocmd BufNewFile,BufRead *.astro set filetype=astro')

vim.keymap.set('n', '<C-c>', '<Esc>')
vim.keymap.set('x', '<C-c>', '<Esc>')
vim.keymap.set('i', '<C-c>', '<Esc>')

vim.keymap.set('n', '<leader>db', ':%bdelete|edit #|normal`"<cr>')

-- Size remaps
vim.keymap.set('n', '<leader>-',  ':vertical resize -10<CR>')
vim.keymap.set('n', '<leader>+', ':vertical resize +10<CR>')

vim.keymap.set('n', '<leader><CR>', ':so ~/.dotfiles/nvim/.config/nvim/init.lua<CR>')

-- Move around (keep the cursor center)
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'n', 'nzzzv')

-- greatest remap ever (paste without override the registery)
vim.keymap.set('x', '<leader>p', "\"_dP")

-- next greatest remap ever : asbjornHaland
vim.keymap.set('n', "<leader>y", "\"+y")
vim.keymap.set('v', "<leader>y", "\"+y")
vim.keymap.set('n', "<leader>Y", "\"+Y", { noremap = false })

vim.keymap.set('n', "<leader>d", "\"_d")
vim.keymap.set('v', "<leader>d", "\"_d")

vim.keymap.set('v', "<leader>d", "\"_d")

vim.keymap.set('n', '<leader><leader>x', ':so %<cr>')
vim.keymap.set('n', '<leader><leader>z', ':LspRestart<cr>')

-- Fzf
vim.keymap.set('n', '<leader>gs', ':G<CR>')
vim.keymap.set('n', '<leader>gf', ':diffget //2<CR>') -- Ours
vim.keymap.set('n', '<leader>gj', ':diffget //3<CR>') -- Theirs
vim.keymap.set('n', '<leader>gp', ':Git push<CR>')
vim.keymap.set('n', '<leader>gl', ':Git pull<CR>')

-- Push upstream for new branch
function GitPushUpsOrgBranch()
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
  vim.cmd("Git push --set-upstream origin " .. branch)
end

vim.keymap.set('n', '<leader>gu', function() GitPushUpsOrgBranch() end)

-- Harpoon
local mark = require('harpoon.mark')
local term = require('harpoon.term')
local ui = require('harpoon.ui')
local silent = { silent = true }

vim.keymap.set('n', "<leader>q", function() mark.add_file() end, silent)
vim.keymap.set('n', "<leader>tc", function() require("harpoon.cmd-ui").toggle_quick_menu() end, silent)

vim.keymap.set('n', "<C-e>", function() ui.toggle_quick_menu() end, silent)
vim.keymap.set('n', "<C-h>", function() ui.nav_file(1) end, silent)
vim.keymap.set('n', "<C-j>", function() ui.nav_file(2) end, silent)
vim.keymap.set('n', "<C-k>", function() ui.nav_file(3) end, silent)
vim.keymap.set('n', "<C-l>", function() ui.nav_file(4) end, silent)

vim.keymap.set('n', "<leader>th", function() term.gotoTerminal(1) end, silent)
vim.keymap.set('n', "<leader>tj", function() term.gotoTerminal(2) end, silent)
vim.keymap.set('n', "<leader>tk", function() term.gotoTerminal(3) end, silent)
vim.keymap.set('n', "<leader>tl", function() term.gotoTerminal(4) end, silent)

-- Lsp
local toggle_qf = function()
  local qf_exists = false
  print(qf_exists)
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd ":copen"
  end
end

-- vim.keymap.set('n', '<C-q>', toggle_qf, { noremap = false })
vim.keymap.set('n', '<C-q>', function() require("trouble").toggle() end)
-- vim.keymap.set('n', '<C-n>', ':cnext<CR>')
vim.keymap.set('n', '<C-n>', function() require("trouble").next({ skip_groups = true, jump = true }) end)
-- vim.keymap.set('n', '<C-p>', ':cprev<CR>')
vim.keymap.set('n', '<C-p>', function() require("trouble").previous({ skip_groups = true, jump = true }) end)

vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

-- Undotree
vim.keymap.set('n', '<F5>', ':UndotreeToggle<CR>')

-- Vim wiki
vim.keymap.set('n', '<leader>,', ':VimwikiToggleListItem<CR>')

-- Clipboard
-- vim.cmd("let g:clipboard = { 'name': 'WslClipboard', 'copy': {    '+': 'clip.exe',    '*': 'clip.exe',  }, 'paste': {    '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',    '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))', }, 'cache_enabled': 0}")
