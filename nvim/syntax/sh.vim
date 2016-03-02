Flow case|if|for|while|until else|elif esac|fi|done
Comments #

setlocal foldmarker=###,### iskeyword+=[,],-

syn cluster D add=PreProc,Expansion
syn keyword Flow then in do continue break return
syn region Command matchgroup=Keyword start=/\v\k+\)@!/ end=/\v%([\n;|)]|\&\d@!)@=/ contains=TOP,Command
syn region Assignment start=/\v\k+\=/ end=/\v\_s/ contains=TOP,Command,Assignment
syn match Continuation '\\\n'
syn match DoubleEscape /\\[$`"\\]/
syn match Error /\v\k+\+\=/
syn match PreProc /\v\$%([-0-9@*#$?!]|\w+)/
syn match String /\v\\./
syn region Expansion matchgroup=PreProc start='$(' end=')' contains=TOP
syn region Expansion matchgroup=PreProc start='$((' end='))'
syn region Expansion matchgroup=PreProc start=/\v\$\{%([-0-9@*#$?!]|\w+)/ end='}'
syn region String matchgroup=Normal start="'" end="'"
syn region String matchgroup=Normal start='"' end='"' contains=DoubleEscape,@D
syn region String matchgroup=Normal start=/\v\<\<\s*\z(\S+)/    end=/\v^\z1$/ contains=@D
syn region String matchgroup=Normal start=/\v\<\<\s*'\z(.{-})'/ end=/\v^\z1$/
syn region String matchgroup=Normal start=/\v\<\<\s*"\z(.{-})"/ end=/\v^\z1$/ contains=@D
