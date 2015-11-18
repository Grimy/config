Comments /* */
syn match CSSError /./
syn region Ok start=/\v[^{]*\{/ end=/}/ contains=String
syn region String matchgroup=Normal start=/\v\k+\s*:\s+/ end=';' contained
hi link CSSError Error
