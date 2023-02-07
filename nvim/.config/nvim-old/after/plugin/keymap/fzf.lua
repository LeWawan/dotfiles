local nnoremap = require('thewawan.keymap').nnoremap

nnoremap('<leader>gs', ':G<CR>')
nnoremap('<leader>gj', ':diffget //3<CR>')
nnoremap('<leader>gf', ':diffget //2<CR>')
nnoremap('<leader>gp', ':Git push<CR>')
nnoremap('<leader>gl', ':Git pull<CR>')

-- Push upstream for new branch
function GitPushUpsOrgBranch()
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
  vim.cmd("Git push --set-upstream origin " .. branch)
end

nnoremap('<leader>gu', function() GitPushUpsOrgBranch() end)
