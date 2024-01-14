-- Things
vim.cmd("autocmd BufWritePre * :%s/\\s\\+$//e")
-- vim.cmd("autocmd BufWritePre *.tsx,*.ts,*.js,*.html,*.css :Prettier")
-- vim.cmd("autocmd BufWritePre *.tsx,*.ts,*.js,*.html,*.css <Plug>(prettier-format)")

-- vim.cmd("autocmd BufWritePre *.go,*.ts,*.vue,*.astro :lua vim.lsp.buf.format()")

-- Autocmd for astro
-- vim.cmd('autocmd BufNewFile,BufRead *.astro set filetype=astro')

vim.keymap.set("n", "<C-c>", "<Esc>")
vim.keymap.set("x", "<C-c>", "<Esc>")
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<leader>db", ':%bdelete|edit #|normal`"<cr>')

-- Size remaps
vim.keymap.set("n", "<leader>-", ":vertical resize -10<CR>")
vim.keymap.set("n", "<leader>+", ":vertical resize +10<CR>")

vim.keymap.set("n", "<leader><CR>", ":so ~/.dotfiles/nvim/.config/nvim/init.lua<CR>")

-- Move around (keep the cursor center)
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "n", "nzzzv")

-- greatest remap ever (paste without override the registery)
vim.keymap.set("x", "<leader>p", '"_dP')

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y', { noremap = false })

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("n", "<leader><leader>x", ":so %<cr>")
vim.keymap.set("n", "<leader><leader>z", ":LspRestart<cr>")

-- move files lines around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

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
		vim.cmd("cclose")
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd(":copen")
	end
end

-- Undotree
vim.keymap.set("n", "<F5>", ":UndotreeToggle<CR>")

-- Vim wiki
vim.keymap.set("n", "<leader>,", ":VimwikiToggleListItem<CR>")

-- Clipboard
-- vim.cmd("let g:clipboard = { 'name': 'WslClipboard', 'copy': {    '+': 'clip.exe',    '*': 'clip.exe',  }, 'paste': {    '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',    '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))', }, 'cache_enabled': 0}")
