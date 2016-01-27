Flow case|if|for|while|until else|elif esac|fi|done
Comments #

syn keyword Flow then in do
syn match Keyword /\v%(^|[;({|`]@<=|\&\d@!)\s*\zs[-a-zA-Z0-9\[\]]+/
syn match Assignment /\v\k+\=/
syn match Continuation /\v\\\n\s*[-a-zA-Z]+/
syn match DoubleEscape /\\[$`"\\]/
syn match Error '+='
syn match PreProc /\v\$%([-0-9@*#$?!]|\k+)/
syn match String /\v\\./
syn region Expansion matchgroup=PreProc start='$(' end=')' contains=ALL
syn region Expansion matchgroup=PreProc start='$((' end='))'
syn region Expansion matchgroup=PreProc start=/\v\$\{%([-0-9@*#$?!]|\k+)/ end='}'
syn region String    matchgroup=Normal  start="'" end="'"
syn region String    matchgroup=Normal  start='"' end='"' contains=DoubleEscape,PreProc,Expansion
syn region String    matchgroup=Normal  start=/\v\<\<\z(\k+)/ end=/\v^\z1$/ contains=PreProc
