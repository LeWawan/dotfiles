local nnoremap = require('thewawan.keymap').nnoremap

nnoremap('<leader>gs', ':G<CR>')
nnoremap('<leader>gj', ':diffget //3<CR>')
nnoremap('<leader>gf', ':diffget //2<CR>')
nnoremap('<leader>gp', ':Git push<CR>')
nnoremap('<leader>gl', ':Git pull<CR>')

-- Push upstream for new branch
function GitPushUpsOrgBranch()
  print('[/!\ Finish me !]')
  local branch  io.popen("git branch --show-current 2>nul")
  print(branch)

end

nnoremap('<leader>gu', function() GitPushUpsOrgBranch() end)
