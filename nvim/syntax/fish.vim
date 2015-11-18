Flow switch|begin|if|for|while|function case|else end
Comments #

syn keyword Flow and or in return
syn match Keyword /\v%(^|[;(|]|\&\d@!)\s*\zs\w+/
syn match PreProc /\v\$[[:alnum:]_]+/
syn match SpecialChar /\v\\[abefnrtv *?~%#(){}\[\]<>&;"']|\\[xX][0-9a-f]{1,2}|\\o[0-7]{1,2}|\\u[0-9a-f]{1,4}|\\U[0-9a-f]{1,8}|\\c[a-z]/
syn region String matchgroup=Normal start="'" end="'" contains=SingleQuoteEscape
syn region String matchgroup=Normal start='"' end='"' contains=DoubleQuoteEscape,PreProc
syn match DoubleQuoteEscape /\\"/
syn match SingleQuoteEscape /\\'/

hi link DoubleQuoteEscape SpecialChar
hi link SingleQuoteEscape SpecialChar
