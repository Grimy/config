syn keyword Flow if else elseif endif
syn keyword Flow for endfor while endwhile
syn keyword Flow function endfunction return

let &l:commentstring = '" %s'
let b:indent_start = '\v^[\t }]*<%(else|elseif|if|for|while|function)>'
let b:indent_end   = '\v^[\t }]*<%(else|endif|endfor|endwhile|endfunction)>'
let b:indent_cont  = '^\s*\'

syn region String matchgroup=Normal start=/'/ end=/'/ contains=SingleEscape oneline
syn region String matchgroup=Normal start='^\@!"' end='"' contains=SpecialChar,ErrorChar oneline
syn region String matchgroup=Normal start='/' end='/' contains=SpecialChar oneline

syn match SingleEscape /''/ contained
hi! link SingleEscape SpecialChar
syn match ErrorChar /\\./ contained
syn match SpecialChar /\v\\(e|\/|[xX]\x{1,2}|[uU]\x{1,4}|\<%([CMS]-)?\k{-}\>)/ contained

autocmd BufWritePost <buffer> source %
