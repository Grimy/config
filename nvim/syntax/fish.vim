Flow switch|begin|if|for|while|function case|else end
syntax match Keyword /\v%(^|[;(|]|\&\d@!)\s*\zs\w+/
syntax keyword Flow and or in return

syntax match PreProc /\v\$[[:alnum:]_]+/
syntax match SpecialChar /\v\\[abefnrtv *?~%#(){}\[\]<>&;"']|\\[xX][0-9a-f]{1,2}|\\o[0-7]{1,2}|\\u[0-9a-f]{1,4}|\\U[0-9a-f]{1,8}|\\c[a-z]/
syntax region String matchgroup=Normal start="'" end="'" contains=SingleQuoteEscape
syntax region String matchgroup=Normal start='"' end='"' contains=DoubleQuoteEscape,PreProc
syntax match DoubleQuoteEscape /\\"/
syntax match SingleQuoteEscape /\\'/
hi link DoubleQuoteEscape SpecialChar
hi link SingleQuoteEscape SpecialChar
