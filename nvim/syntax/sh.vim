Flow case|if|for|while|until else|elif esac|fi|done
Comments #

syn match Keyword /\v%(^|[;({|`]|\&\d@!)\s*\zs\w+>\=@!/
syn keyword Flow then in do
syn match Error '+='
syn match PreProc /\v\$%([-0-9@*#$?!]|\k+)/
syn region PreProc matchgroup=PreProc start=/\v\$\{%([-0-9@*#$?!]|\k+)/ end='}' transparent
syn match String /\v\\./
syn region String matchgroup=Normal start="'" end="'"
syn region String matchgroup=Normal start='"' end='"' contains=DoubleQuoteEscape,PreProc
syn region String matchgroup=Normal start=/\v\<\<\z(\k+)/ end=/\v^\z1$/ contains=PreProc
syn match DoubleQuoteEscape /\\[$`"\\]/
hi link DoubleQuoteEscape SpecialChar
hi link Parameter String
