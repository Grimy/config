Flow if|for|do|while|try|switch else|catch|finally|case|default 
Comments //

syn keyword Error goto
syn keyword Flow break continue return throw assert
syn keyword Keyword public protected private abstract static throws
syn keyword Keyword enum interface class package implements extends
syn keyword Keyword true false null new this super instanceof
syn keyword PreProc import
syn keyword Type final transient volatile synchronized strictfp native
syn keyword Type void boolean char short int long float double

syn match PreProc /@\w*/
syn region Comment start='\V/*' end='\V*/'

syn region Character matchgroup=Normal start="'"  end="'" contains=SpecialChar,ErrorChar oneline
syn region String    matchgroup=Normal start='"'  end='"' contains=SpecialChar,ErrorChar oneline
syn match SpecialChar /\v\\('|u+\x{4})/

setlocal textwidth=96
setlocal formatlistpat=@
set suffixes+=.class

inoreabbrev <silent> <buffer> syso System.out.println();<Left><Left>
inoremap . .<C-X><C-O><C-P>
