Flow case|if|for|while|until else|elif esac|fi|done braces
Comments #

setlocal iskeyword+=[,],-,+,.,: tabstop=4
let &l:makeprg = 'shellcheck -x -fgcc --exclude=SC2016,SC1071,SC2046,SC2086 %'

syn cluster D add=PreProc,Expansion
syn keyword Flow then in do continue break return
syn region Command matchgroup=Keyword start=/\v\k+/ end=/\v%([\n;|)]|\&\d@!)@=/ contains=TOP,Command
syn region Assignment start=/\v\k+\=/ end=/\v[\n; |)]@=/ contains=TOP,Command,Assignment
syn match Continuation '\\\n'
syn match DoubleEscape /\\[$`"\\]/
syn match Error /\v\k+\+\=/
syn match PreProc /\v\$%([-0-9@*#$?!]|\w+)/
syn match String /\v\\./
syn match Normal /\v^\s*\k+\)/
syn region Expansion matchgroup=PreProc start='$(' end=')' contains=TOP
syn region Expansion matchgroup=PreProc start='$((' end='))'
syn region Expansion matchgroup=PreProc start=/\v\$\{%([-0-9@*#$?!]|\w+)%(:?[-=?+]|[#%]{1,2}|}@=)/ end='}' transparent
syn region String matchgroup=Normal start="'" end="'"
syn region String matchgroup=Normal start='"' end='"' contains=DoubleEscape,@D
syn region String matchgroup=Normal start=/\v\<\<\s*-?\z(\k+)/    end=/\v^\s*\z1$/ contains=@D
syn region String matchgroup=Normal start=/\v\<\<\s*-?'\z(.{-})'/ end=/\v^\s*\z1$/
syn region String matchgroup=Normal start=/\v\<\<\s*-?"\z(.{-})"/ end=/\v^\s*\z1$/ contains=@D
