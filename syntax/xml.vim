syntax region XMLTag start='<' end='>' keepend contains=Error,Keyword,String
syntax match Error /./ contained
syntax match Keyword /\v\<[\/?]?\k+/ contained
syntax match Normal  /\v\<[\/?]?/ contained containedin=Keyword
syntax match Normal  /\v\_s*[\/?]?\>/ contained containedin=XMLTag
syntax region String matchgroup=Normal start=/\v\_s+\k+\_s*\=\_s*\z(["'])/ end=/\z1/ contained
syntax match PreProc /\v\&.{-};/

setlocal synmaxcol=300
setlocal iskeyword+=:
setlocal commentstring=<!--\ %s\ -->
