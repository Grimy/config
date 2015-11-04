syntax match CSSError /./
syntax region Ok start=/\v[^{]*\{/ end=/}/ contains=String
syntax region String matchgroup=Normal start=/\v\k+\s*:\s+/ end=';' contained
hi link CSSError Error
