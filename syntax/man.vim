nnoremap <buffer> <CR> K

" Presentation options
setlocal tabstop=8
setlocal synmaxcol&
setlocal colorcolumn=
setlocal nolist nowrap nofoldenable nonumber

" The screen moves in sync with the cursor
autocmd BufEnter <buffer> set scrolloff=999 scrolljump=1
autocmd BufLeave <buffer> set scrolloff=20  scrolljump=4
normal! M0

" Don’t save
setlocal buftype=nofile bufhidden=hide noswapfile nomodifiable

" Title
syn match Todo /\v%^.*|.*%$/

" Escape sequences
syn region String matchgroup=Normal start=/\v\e\[.{-}m/ end=/\v\e\[.{-}m/ concealends
syn region Todo matchgroup=Normal start=/\v^%(   )?\zs\e\[.{-}m/ end=/\v\e\[.{-}m/ concealends

" Options
syn match Keyword /\vm@<=-%([^-]|[a-z-]+)/ contained containedin=String

if getline(1) =~ '([23])$'
	syntax include @C <sfile>:p:h/c.vim
	syn match FuncDefinition display /\<\h\w*\>\s*(/me=e-1 contained
	syn region manSynopsis start=/SYNOPSIS\zs/ end=/\v\e@=/ keepend contains=Todo,@C,FuncDefinition
endif
