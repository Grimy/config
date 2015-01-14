syn keyword Conditional if else switch
syn keyword Keyword sizeof inline
syn keyword Label case default break continue goto return
syn keyword Repeat for do while
syn keyword StorageClass static extern auto register
syn keyword Structure enum struct union typedef
syn keyword Type const volatile restrict
syn keyword Type void char short unsigned signed int long float double _Bool _Imaginary _Complex

syn match PreProc /#\w*/
syn region Comment start='\V/*' end='\V*/'
syn match Comment '//.*'

syn region Character matchgroup=Normal start="'" end="'" contains=SpecialChar,ErrorChar oneline
syn region String    matchgroup=Normal start='"' end='"' contains=SpecialChar,ErrorChar oneline
syn match ErrorChar /\\./
syn match SpecialChar /\v\\([av'?]|x\x{1,2}|u\x{4})/ contained

setlocal textwidth=80
