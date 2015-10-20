let &l:commentstring = '! %s'
autocmd BufWritePost <buffer> !xrdb merge %
