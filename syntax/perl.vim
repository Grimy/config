syn keyword Error given when continue break
syn keyword Flow if else elsif unless default do while until for foreach continue
syn keyword Flow return last next redo goto
syn keyword Keyword defined undef eq ne le lt ge gt cmp not and or xor bless ref
syn keyword Keyword my our local state
syn keyword Keyword chomp chop chr crypt index rindex lc lcfirst uc ucfirst length ord pack sprintf substr vec
syn keyword Keyword pos quotemeta split study
syn keyword Keyword abs atan cos exp hex int log oct rand sin sqrt srand
syn keyword Keyword splice unshift shift push pop join reverse grep map sort unpack
syn keyword Keyword delete each exists keys values
syn keyword Keyword syscall dbmopen dbmclose
syn keyword Keyword binmode close eof fileno getc lstat print printf line pipe say select stat tell
syn keyword Keyword fcntl flock ioctl open read seek sys write truncate
syn keyword Keyword chmod chown glob link readlink rename symlink umask unlink utime
syn keyword Keyword mkdir chdir rmdir seekdir readdir telldir opendir closedir rewinddir chroot
syn keyword Keyword caller die dump eval exit wantarray
syn keyword Keyword require import use no
syn keyword Keyword alarm exec fork kill sleep system times wait pid
syn keyword Keyword accept bind connect listen recv send setsockopt shutdown socket pair
syn keyword Keyword localtime time
syn keyword Keyword warn format formline reset scalar prototype lock tied untie
syn keyword PreProc BEGIN CHECK INIT END UNITCHECK

setlocal iskeyword+=$,@,%,&
syn region String matchgroup=Normal start="'" end="'" contains=SingleEscape
syn region String matchgroup=Normal start='"' end='"' contains=SpecialChar,ErrorChar,Interpolation
syn region String matchgroup=Normal start='`' end='`' contains=SpecialChar,ErrorChar,Interpolation
syn region String matchgroup=Normal start='/' skip='\\.' end='/' contains=SpecialChar oneline

syn match SingleEscape /\\[\\']/ contained
hi! link SingleEscape SpecialChar
syn match ErrorChar /\\./
syn match SpecialChar /\v\\([aesv]|c.|[MC]-.|M-\\C-.|x\x{1,2}|u\x{4})/ contained
syn region Interpolation matchgroup=SpecialChar start=/\v\k+\[/ end=']' contains=TOP
syn region Interpolation matchgroup=SpecialChar start=/\v\k+\{/ end='}' contains=TOP
syn region Interpolation matchgroup=SpecialChar start=/\v\k+/ end='\b'
