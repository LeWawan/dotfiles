local Remap = require'thewawan.keymap'
local nnoremap = Remap.nnoremap
local nmap = Remap.nmap

nnoremap('<C-n>', ':cnext<CR>')
nnoremap('<C-p>', ':cprev<CR>')


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

nmap('<C-q>', toggle_qf)
