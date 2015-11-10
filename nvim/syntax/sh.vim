Flow case|if|for|while|until else|elif esac|fi|done
syntax match Keyword /\v%(^|[;({|`]|\&\d@!)\s*\zs\w+>\=@!/
syntax keyword Flow then in do

syntax match Error '+='
syntax match PreProc /\v\$%([-0-9@*#$?!]|\k+)/
syntax region PreProc matchgroup=PreProc start=/\v\$\{%([-0-9@*#$?!]|\k+)/ end='}' transparent
syntax match String /\v\\./
syntax region String matchgroup=Normal start="'" end="'"
syntax region String matchgroup=Normal start='"' end='"' contains=DoubleQuoteEscape,PreProc
syntax region String matchgroup=Normal start=/\v\<\<\z(\k+)/ end=/\v^\z1$/ contains=PreProc
syntax match DoubleQuoteEscape /\\[$`"\\]/
hi link DoubleQuoteEscape SpecialChar
hi link Parameter String
