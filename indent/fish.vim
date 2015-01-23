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
