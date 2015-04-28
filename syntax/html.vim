runtime! syntax/xml.vim

syntax region QuotelessString matchgroup=Normal start=/\v(^|\s)\_s*\k+\_s*\=\_s*\k@=/ end=/\>/ contained containedin=XMLTag
hi link QuotelessString String
syntax region CSS matchgroup=Normal start=/\v\<style.{-}\>/ end='</style' contains=@CSS
syntax include @CSS syntax/css.vim
syntax region JS matchgroup=Normal start=/\v\<script.{-}\>/ end='</script' contains=@JS
syntax include @JS syntax/js.vim
