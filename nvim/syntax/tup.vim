Flow ifeq|ifneq|ifdef|ifndef else endif
Comments #

syn keyword PreProc include include_rules run preload
syn match PreProc /^\s*.gitignore\s*$/
syn match Flow '|>'

syn match LineContinuation /\\$/
syn region Rule matchgroup=Repeat start=/\v^\s*:\s*(foreach>)?/ end=/\n/
syn region Command matchgroup=Repeat start=/|>/ end=/|>/ contained containedin=Rule

syn match PreProc /%[bBdefgoO]/ contained containedin=Command,Rule
