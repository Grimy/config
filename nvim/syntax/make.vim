syntax match PreProc /\v$[^(]/
syntax region PreProc start='$(' end=')' contains=PreProc
