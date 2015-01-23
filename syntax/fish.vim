syntax keyword Conditional if else end switch and or
syntax keyword Repeat while for in
syntax keyword Label case begin function return

syntax match Comment /#.*/
syntax match Special /\\$/
syntax match Identifier /\$[[:alnum:]_]\+/
syntax region String start=/'/ skip=/\\'/ end=/'/
syntax region String start=/"/ skip=/\\"/ end=/"/ contains=fishIdentifier
syntax match Character /\v\\[abefnrtv *?~%#(){}\[\]<>&;"']|\\[xX][0-9a-f]{1,2}|\\o[0-7]{1,2}|\\u[0-9a-f]{1,4}|\\U[0-9a-f]{1,8}|\\c[a-z]/
syntax match Statement /\v;\s*\zs\k+>/
syntax match CommandSub /\v\(\s*\zs\k+>/

syntax region fishLineContinuation matchgroup=fishStatement
            \ start='\v^\s*\zs\k+>' skip='\\$' end='$'
            \ contains=fishSpecial,fishIdentifier,fishString,fishCharacter,fishStatement,fishCommandSub
