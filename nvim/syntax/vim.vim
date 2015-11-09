Flow if|for|while|function else|elseif endif|endfor|endwhile|endfunction
Comments "

setlocal iskeyword+=:,#
nnoremap <buffer> K :vert help <C-R><C-W><CR>

function! s:abbr(lhs, rhs)
	return a:lhs . ' ' . a:lhs . '<End><CR>' . a:rhs . '<Up><End>'
endfunction

command! -nargs=+ Abbr execute 'inoreabbrev <buffer>' s:abbr(<f-args>)
Abbr function endfunction

syn match PreProc /\v\<%([fq]-args|args|bang|line[12]|count|reg|lt)\>/

syn region String matchgroup=Normal start=/'/ end=/'/ contains=SingleEscape oneline
syn region String matchgroup=Normal start='^\@!"' end='"' contains=SpecialChar,ErrorChar oneline
syn region String matchgroup=Normal start=/\v\/%(\\v)@=/ end='/' contains=SpecialChar oneline

syn match SingleEscape /''/ contained
hi! link SingleEscape SpecialChar
syn match SpecialChar /\v\\(e|\/|[xX]\x{1,2}|[uU]\x{1,4}|\<%([CMS]-)?%(\k{-}|.)\>)/ contained
