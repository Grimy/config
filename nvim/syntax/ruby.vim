Flow begin|case|if|for|do|while|def|class else|elsif|when|rescue|ensure end
syn keyword Flow if then unless else elsif end for in do while until
syn keyword Flow begin rescue ensure
syn keyword Flow next redo retry break case when return and or
syn keyword Keyword defined? nil self super undef
syn keyword Keyword module class def alias
syn keyword Keyword true false not
syn keyword PreProc require BEGIN END __ENCODING__ __END__ __FILE__ __LINE__

syn region String matchgroup=Normal start="'" end="'" contains=SingleEscape
syn region String matchgroup=Normal start='"' end='"' contains=SpecialChar,ErrorChar,Interpolation
syn region String matchgroup=Normal start='`' end='`' contains=SpecialChar,ErrorChar,Interpolation
syn region String matchgroup=Normal start='/' skip='\\.' end='/' contains=SpecialChar oneline

syn match SingleEscape /\\[\\']/ contained
hi! link SingleEscape SpecialChar
syn match SpecialChar /\v\\([aesv]|c.|[MC]-.|M-\\C-.|x\x{1,2}|u\x{4})/ contained
syn region Interpolation matchgroup=SpecialChar start='#{' end='}' contains=TOP

let b:indent_start .= '|\|$'
