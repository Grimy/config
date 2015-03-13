syn keyword Conditional if else switch assert
syn keyword Repeat for do while
syn keyword Label case default break continue return
syn keyword StorageClass public protected private abstract static
syn keyword Structure enum interface class package implements extends
syn keyword PreProc import
syn keyword Exception try catch finally throw throws
syn keyword Type final transient volatile synchronized strictfp native
syn keyword Type void boolean char short int long float double
syn keyword Boolean true false
syn keyword Keyword null new this super instanceof
syn keyword Error goto

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
