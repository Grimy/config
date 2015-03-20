syn keyword Error goto
syn keyword Flow if else switch for do while
syn keyword Flow case default break continue return
syn keyword Flow try catch finally throw throws assert
syn keyword Keyword public protected private abstract static
syn keyword Keyword enum interface class package implements extends
syn keyword Keyword true false null new this super instanceof
syn keyword PreProc import
syn keyword Type final transient volatile synchronized strictfp native
syn keyword Type void boolean char short int long float double

syn match PreProc /@\w*/
syn region Comment start='\V/*' end='\V*/'
let &l:commentstring = '// %s'

let b:indent_cont  = '\v^\s*%([\-+*%&|^~!?:<=>,]|//@!)'
let b:indent_start = '\v^[\t }]*<%(else|catch|finally|case|default|if|for|do|while|try|switch)>|\{$'
let b:indent_end   = '\v^[\t }]*<%(else|catch|finally|case|default)>|^\s*\}'

syn region Character matchgroup=Normal start="'"  end="'" contains=SpecialChar,ErrorChar oneline
syn region String    matchgroup=Normal start='"'  end='"' contains=SpecialChar,ErrorChar oneline
syn match ErrorChar /\\./
syn match SpecialChar /\v\\('|u+\x{4})/

setlocal textwidth=96
setlocal formatlistpat=@
setlocal number
set suffixes+=.class

inoreabbrev <silent> <buffer> syso System.out.println();<Left><Left>
