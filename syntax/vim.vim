syn keyword Conditional if else elseif endif
syn keyword Repeat for endfor while endwhile
syn keyword Label function endfunction return

let &l:commentstring='" %s'

syn region String matchgroup=Normal start=/'/ end=/'/ contains=SingleEscape oneline
syn region String matchgroup=Normal start='^\@!"' end='"' contains=SpecialChar,ErrorChar oneline
syn region String matchgroup=Normal start='/' end='/' contains=SpecialChar oneline

syn match SingleEscape /''/ contained
hi! link SingleEscape SpecialChar
syn match ErrorChar /\\./ contained
syn match SpecialChar /\v\\(e|\/|[xX]\x{1,2}|[uU]\x{1,4}|\<\k{-}\>)/ contained
