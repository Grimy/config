Flow $. $.
Comments <!-- -->

syn region XMLTag start='<!\@!' end='>' keepend
syn match Error /./ contained containedin=XMLTag
syn match Keyword /\v\<[\/?]?\i+/ contained containedin=XMLTag
syn match Normal  /\v\<[\/?]?/ contained containedin=Keyword
syn match Normal  /\v\_s*[\/?]?\>/ contained containedin=XMLTag
syn region String matchgroup=Normal start=/\v(^|\s)\_s*\i+\_s*\=\_s*\z(["'])/ end=/\z1/ contained containedin=XMLTag
syn match PreProc /\v\&.{-};/
syn region PreProc start='<!-\@!' end='>'

setlocal isident+=:,-,.
