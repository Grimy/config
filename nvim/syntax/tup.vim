syntax keyword PreProc include include_rules run preload
syntax match PreProc /^\s*.gitignore\s*$/
syntax keyword Flow ifeq ifneq ifdef ifndef else endif
syntax match Flow '|>'

syntax match LineContinuation /\\$/
syntax region Rule matchgroup=Repeat start=/\v^\s*:\s*(foreach>)?/ end=/\n/
syntax region Command matchgroup=Repeat start=/|>/ end=/|>/ contained containedin=Rule

syntax match PreProc /%[bBdefgoO]/ contained containedin=Command,Rule
