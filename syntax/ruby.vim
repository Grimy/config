syn keyword Boolean true false and or not
syn keyword Conditional if then unless else elsif end
syn keyword Exception begin rescue ensure
syn keyword Keyword defined? nil self super undef
syn keyword Label next redo retry break case when return
syn keyword PreProc BEGIN END __ENCODING__ __END__ __FILE__ __LINE__
syn keyword Repeat for in do while until
syn keyword Structure module class def alias

syn match Comment /#.*/

syn region String matchgroup=Normal start="'" end="'" contains=SingleEscape
syn region String matchgroup=Normal start='"' end='"' contains=SpecialChar,ErrorChar,Interpolation
syn region String matchgroup=Normal start='/' skip='\\.' end='/' contains=SpecialChar oneline

syn match SingleEscape /\\[\\']/ contained
hi! link SingleEscape SpecialChar
syn match ErrorChar /\\./
syn match SpecialChar /\v\\([aesv]|c.|[MC]-.|M-\\C-.|x\x{1,2}|u\x{4})/ contained
syn region Interpolation matchgroup=SpecialChar start='#{' end='}'
