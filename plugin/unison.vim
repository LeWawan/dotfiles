" Custom
nnoremap <leader>sc :!unison-2.48 -sshargs '-C'  -prefer newer  -confirmbigdel  -ignorecase false  -ignore 'Path private/symfony4/var'  -ignore 'Path logs_apache'  -ignore 'Path */*/node_modules'  -ignore 'Path private/vendor'  -ignore 'Path logs_appli'  -batch '/Users/mbp13-montagnes/Lab/erwan' ssh://www-data@solaroc.compilatio.net//home/sites/erwan<CR>


