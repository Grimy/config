syn keyword Conditional if else switch assert
syn keyword Repeat for do while
syn keyword Label case default break continue return
syn keyword StorageClass public protected private static
syn keyword Structure enum interface class package import implements extends
syn keyword Exception try catch finally throw throws
syn keyword Type final transient volatile synchronized strictfp native
syn keyword Type void char short int long float double
syn keyword Boolean true false
syn keyword Keyword null new this super instanceof
syn keyword Error goto

syn match PreProc /@\w*/
syn region Comment start='\V/*' end='\V*/'
syn match Comment '//.*'

syn region Character matchgroup=Normal start="'"  end="'" contains=SpecialChar,ErrorChar oneline
syn region String    matchgroup=Normal start='"'  end='"' contains=SpecialChar,ErrorChar oneline
syn match ErrorChar /\\./
syn match SpecialChar /\v\\('|u+\x{4})/

setlocal textwidth=96
setlocal formatlistpat=@
