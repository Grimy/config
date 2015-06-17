setlocal iskeyword+=:,#
setlocal number
nnoremap <buffer> K :vert help <C-R><C-W><CR>

" Reload vim files after saving them
autocmd BufWritePost <buffer> source % | setf vim

function! s:abbr(lhs, rhs)
	return a:lhs . ' ' . a:lhs . '<End><CR>' . a:rhs . '<Up><End>'
endfunction

command! -nargs=+ Abbr execute 'inoreabbrev <buffer>' s:abbr(<f-args>)
Abbr function endfunction

syn keyword Flow if else elseif endif try catch finally endtry
syn keyword Flow for in endfor while endwhile break continue
syn keyword Flow function endfunction return finish

let &l:commentstring = '" %s'
let b:indent_start = '\v^[\t }]*<%(else|elseif|if|for|while|function)>'
let b:indent_end   = '\v^[\t }]*<%(else|end%(if|for|while|function))>'
let b:indent_cont  = '^\s*\'

syn region String matchgroup=Normal start=/'/ end=/'/ contains=SingleEscape oneline
syn region String matchgroup=Normal start='^\@!"' end='"' contains=SpecialChar,ErrorChar oneline
syn region String matchgroup=Normal start='/' end='/' contains=SpecialChar oneline

syn match SingleEscape /''/ contained
hi! link SingleEscape SpecialChar
syn match ErrorChar /\\./ contained
syn match SpecialChar /\v\\(e|\/|[xX]\x{1,2}|[uU]\x{1,4}|\<%([CMS]-)?%(\k{-}|.)\>)/ contained
