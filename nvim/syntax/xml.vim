syntax region XMLTag start='<' end='>' keepend
syntax match Error /./ contained containedin=XMLTag
syntax match Keyword /\v\<[\/?]?\k+/ contained containedin=XMLTag
syntax match Normal  /\v\<[\/?]?/ contained containedin=Keyword
syntax match Normal  /\v\_s*[\/?]?\>/ contained containedin=XMLTag
syntax region String matchgroup=Normal start=/\v(^|\s)\_s*\k+\_s*\=\_s*\z(["'])/ end=/\z1/ contained containedin=XMLTag
syntax match PreProc /\v\&.{-};/
syntax region PreProc start='<!' end='>'

setlocal synmaxcol=0
setlocal iskeyword+=:,-,/
let &l:commentstring = '<!-- %s -->'
let b:indent_start = '^\s*<\k'
let b:indent_end = '^\s*</\|/>$'
let b:indent_cont = '/>$'
