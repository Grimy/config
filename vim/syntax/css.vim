syn match Error /./
Comments /* */
syn region Ok start=/\v[^{]*\{/ end=/}/ contains=CSSString
syn region CSSString matchgroup=Normal start=/\v\k+\s*:\s+/ end=/\v%(;|\s*\}@=)/ contained
syn region Normal matchgroup=PreProc start=/\v\@media\s*\(.{-}\)\s*\{/ end='}' contains=TOP
hi! link CSSString String
