syntax keyword Conditional if else end switch and or
syntax keyword Repeat while for in
syntax keyword Label case begin function return

syntax match Comment /#.*/
let &l:commentstring='#\ %s'

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
function! FishIndent()
    let l:prevlnum = prevnonblank(v:lnum - 1)
    if l:prevlnum ==# 0
        return 0
    endif
    let l:indent = 0
    let l:prevline = getline(l:prevlnum)
    if l:prevline =~# '\v^\s*switch>'
        let l:indent = &shiftwidth * 2
    elseif l:prevline =~# '\v^\s*%(begin|if|else|while|for|function|case)>'
        let l:indent = &shiftwidth
    endif
    let l:line = getline(v:lnum)
    if l:line =~# '\v^\s*end>'
        return indent(v:lnum) - (l:indent ==# 0 ? &shiftwidth : l:indent)
    elseif l:line =~# '\v^\s*%(case|else)>'
        return indent(v:lnum) - &shiftwidth
    endif
    return indent(l:prevlnum) + l:indent
endfunction

function! s:FishErrorFormat()
    return '%Afish: %m,%-G%*\\ ^,%-Z%f (line %l):%s'
endfunction

setlocal indentexpr=FishIndent()
setlocal indentkeys+==end,=else,=case
