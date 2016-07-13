Flow $. $.
Comments <!-- -->

syn region XMLTag start='<!\@!' end='>' keepend
syn match Error /./ contained containedin=XMLTag
syn match Keyword /\v\<[\/?]?\k+/ contained containedin=XMLTag
syn match Normal  /\v\<[\/?]?/ contained containedin=Keyword
syn match Normal  /\v\_s*[\/?]?\>/ contained containedin=XMLTag
syn region String matchgroup=Normal start=/\v(^|\s)\_s*\k+\_s*\=\_s*\z(["'])/ end=/\z1/ contained containedin=XMLTag
syn match PreProc /\v\&.{-};/
syn region PreProc start='<!-\@!' end='>'

setlocal iskeyword+=:,-
let b:indent_start = '^\s*<\k'
let b:indent_end = '^\s*</\|/>$'
let b:indent_cont = '/>$'
