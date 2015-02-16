let &l:commentstring='# %s'
syntax match Comment /\v#.*/
syntax match PreProc /\v$[^(]/
syntax region PreProc start='$(' end=')' contains=PreProc
