runtime syntax/ctrlh.vim

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
