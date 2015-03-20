syntax keyword Flow if else end switch and or while for in
syntax keyword Flow case begin function return

syntax match Special /\\$/
syntax match Identifier /\$[[:alnum:]_]\+/
syntax region String start=/'/ skip=/\\'/ end=/'/
syntax region String start=/"/ skip=/\\"/ end=/"/
syntax match Character /\v\\[abefnrtv *?~%#(){}\[\]<>&;"']|\\[xX][0-9a-f]{1,2}|\\o[0-7]{1,2}|\\u[0-9a-f]{1,4}|\\U[0-9a-f]{1,8}|\\c[a-z]/
syntax match Statement /\v;\s*\zs\k+>/
syntax match CommandSub /\v\(\s*\zs\k+>/

syntax region fishLineContinuation matchgroup=fishStatement
            \ start='\v^\s*\zs\k+>' skip='\\$' end='$'
            \ contains=fishSpecial,fishString,fishCharacter,fishStatement,fishCommandSub
