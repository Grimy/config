" Follow tags with Return
Map n <buffer> K <C-]>
Map n <buffer> <CR> <C-]>
setlocal iskeyword+=:,#
autocmd BufEnter <buffer> set scrolloff=999 scrolljump=1
autocmd BufLeave <buffer> set scrolloff=20  scrolljump=4
