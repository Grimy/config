nnoremap <buffer> K <C-]>
nnoremap <buffer> <CR> <C-]>
setlocal iskeyword+=-,:,# nolist

syn region Example  matchgroup=helpIgnore start=" >$" start="^>$" end="^[^ \t]"me=e-1 end="^<" concealends
syn keyword Todo    note Note NOTE note: Note: NOTE: Notes Notes:
syn match Statement "^[-A-Z .][-A-Z0-9 .()]*[ \t]\+\*"me=e-1
syn match String    /\v([*|])%(\k|[.-])+\1/
syn match PreProc   /\v^[-=]+$/
syn match Keyword   /\vN?VIM REFERENCE.*/
syn match Keyword   /\v'[a-z_]{2,}'/
syn match Special   "{[-a-zA-Z0-9'"*+/:%#=[\]<>.,]\+}"
syn match Special   "<[-a-zA-Z0-9_]*.>"
syn match Special   /\v\[%(range|line|count|offset|\+?cmd|[+-]?num|\+\+opt|arg|arguments|ident|addr|group)\]/
