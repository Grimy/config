Comments #
syn match PreProc /\v$[^(]/
syn region PreProc start='$(' end=')' contains=PreProc
