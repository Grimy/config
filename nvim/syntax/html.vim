runtime! syntax/xml.vim

" Do not treat quoteless or boolean attributes as errors
syn region String matchgroup=Normal start=/\v(^|\s)\_s*\k+\_s*\=\_s*%(\k|\/)@=/ end=/\v>\/@!/ contained containedin=XMLTag
syn keyword Normal required checked selected disabled contained containedin=Error

syn region TT matchgroup=PreProc start='\[%' end='%\]' containedin=XMLTag
syn region CSS matchgroup=Normal start=/\v\<style.{-}\>/ end='</style' contains=@CSS
syn region JS matchgroup=Normal start=/\v\<script.{-}\>/ end='</script' contains=@JS
syn include @CSS syntax/css.vim
syn include @JS syntax/js.vim
