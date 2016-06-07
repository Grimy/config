Flow augroup%(\sEND)@!|if|for|while|function else|elseif augroup\sEND|endif|endfor|endwhile|endfunction
Comments "

setlocal iskeyword+=:,# indentkeys+=,0\
nnoremap <buffer> K :vert help <C-R><C-W><CR>

inoreabbrev <buffer> function function!() abort<End><CR>endfunction<Left><Left><Up>

syn keyword Flow return augroup END continue break
syn match PreProc /\v\<%([fq]-args|args|bang|line[12]|count|reg|lt)\>/

syn region String matchgroup=Normal start=/'/ end=/'/ contains=SingleEscape oneline
syn region String matchgroup=Normal start='^\@!"' end='"' contains=SpecialChar,ErrorChar oneline
syn region String matchgroup=Normal start=/\v\/%(\\v)@=/ end='/' contains=SpecialChar oneline

syn match SingleEscape /''/ contained
syn match SpecialChar /\v\\(e|\/|[xX]\x{1,2}|[uU]\x{1,4}|\<%([CMS]-)?%(\k{-}|.)\>)/ contained

let b:indent_cont = '^\s*\\'
