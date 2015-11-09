Flow if|for|do|while|try|switch else|catch|finally|case|default
Comments //

syn keyword Flow break continue goto return
syn keyword Keyword sizeof inline
syn keyword Keyword static extern auto register
syn keyword Type enum struct union typedef
syn keyword Type const volatile restrict
syn keyword Type void char short unsigned signed int long float double _Bool _Imaginary _Complex

syn match PreProc /#\w*/
syn region Comment start='\V/*' end='\V*/'

syn region Character matchgroup=Normal start="'" end="'" contains=SpecialChar,ErrorChar oneline
syn region String    matchgroup=Normal start='"' end='"' contains=SpecialChar,ErrorChar oneline
syn match SpecialChar /\v\\([aev'?]|x\x{1,2}|u\x{4})/ contained

setlocal textwidth=80
