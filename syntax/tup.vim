syntax keyword Include include include_rules run preload
syntax match Include /^\s*.gitignore\s*$/
syntax keyword Conditional ifeq ifneq ifdef ifndef else endif
syntax match Keyword '|>'

syntax match Comment /^\s*#.*/
let &l:commentstring='# %s'

syntax match LineContinuation /\\$/
syntax region Rule matchgroup=Repeat start=/\v^\s*:\s*(foreach>)?/ end=/\n/
syntax region Command matchgroup=Repeat start=/|>/ end=/|>/ contained containedin=Rule

syntax match PreProc /%[bBdefgoO]/ contained containedin=Command,Rule
