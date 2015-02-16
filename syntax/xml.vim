syntax region XMLTag start='<' end='>' keepend contains=Error,Keyword,String
syntax match Error /./ contained
syntax match Keyword /\v\<[\/?]?\k+/ contained
syntax match Normal  /\v\<[\/?]?/ contained containedin=Keyword
syntax match Normal  /\v\_s*[\/?]?\>/ contained containedin=XMLTag
syntax region String matchgroup=Normal start=/\v(^|\s)\_s*\k+\_s*\=\_s*\z(["'])/ end=/\z1/ contained
syntax match PreProc /\v\&.{-};/
syntax region PreProc start='<!' end='>'

setlocal synmaxcol=0
setlocal iskeyword+=:,-
let &l:commentstring='<!-- %s -->'
