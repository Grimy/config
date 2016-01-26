" Follow tags with Return
nnoremap <buffer> K <C-]>
nnoremap <buffer> <CR> <C-]>
setlocal iskeyword+=:,#
autocmd BufEnter <buffer> set scrolloff=999 scrolljump=1
autocmd BufLeave <buffer> set scrolloff=20  scrolljump=4

syn region Comment    matchgroup=helpIgnore start=" >$" start="^>$" end="^[^ \t]"me=e-1 end="^<" concealends
syn keyword Todo      note Note NOTE note: Note: NOTE: Notes Notes:
syn match Statement   "^[-A-Z .][-A-Z0-9 .()]*[ \t]\+\*"me=e-1
syn match PreProc     "^===.*===$"
syn match PreProc     "^---.*--$"
syn match String      "\\\@<!|[#-)!+-~]\+|" contains=Ignore
syn match String      "\*[#-)!+-~]\+\*\s"he=e-1 contains=Ignore
syn match String      "\*[#-)!+-~]\+\*$" contains=Ignore
syn match Ignore      contained "[.|`*]" conceal
syn match Keyword     /\vN?VIM REFERENCE.*/
syn match Keyword     /\v'[a-z_]{2,}'/
syn match Comment     "`[^` \t]\+`"hs=s+1,he=e-1 contains=Ignore
syn match PreProc     "\s*\zs.\{-}\ze\s\=\~$" nextgroup=helpIgnore
syn match Special     "{[-a-zA-Z0-9'"*+/:%#=[\]<>.,]\+}"
syn match Special     "\s\[[-a-z^A-Z0-9_]\{2,}]"ms=s+1
syn match Special     "<[-a-zA-Z0-9_]\+>"
syn match Special     "<[SCM]-.>"
syn match Special     /\v\[%(range|line|count|offset|\+?cmd|[+-]?num|\+\+opt|arg|arguments|ident|addr|group)\]/
syn match String      `\v<[a-z]+://[^' <>"]+`
