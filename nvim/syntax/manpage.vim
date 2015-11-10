nnoremap <buffer> <CR> K
let $COLUMNS = &columns

" Presentation options
setlocal tabstop=8
setlocal colorcolumn=
setlocal iskeyword+=.
setlocal nolist nowrap nofoldenable nonumber

" The screen moves in sync with the cursor
autocmd BufEnter <buffer> set scrolloff=999 scrolljump=1
autocmd BufLeave <buffer> set scrolloff=20  scrolljump=4
normal! M0

" Don’t save
setlocal buftype=nofile bufhidden=hide noswapfile

syn case ignore

" Reference to other man pages
syn match String /\f\+([1-9][a-z]\=)/

" Title
syn match Todo /^\f\+([0-9]\+[a-z]\=).*/

" Section heading
syn match Todo /^[a-z][a-z ]*[a-z]$/

" Subsection heading
syn match Todo /^\s\{3\}[a-z][a-z ]*[a-z]$/

" Options
syn match Keyword /\v\W\zs--?(\k|-)+/ containedin=ALL

if getline(1) =~ '^[a-zA-Z_]\+([23])'
        syntax include @C <sfile>:p:h/c.vim
        syn match FuncDefinition display /\<\h\w*\>\s*(/me=e-1 contained
        syn region manSynopsis start=/^SYNOPSIS/hs=s+8 end=/^\u\+\s*$/me=e-12 keepend contains=Todo,@C,FuncDefinition
endif
