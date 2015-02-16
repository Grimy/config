let &l:commentstring='# %s'

syn match Keyword /On branch \zs.*/ contained containedin=Comment
syn match Keyword /Your branch is \zs.*\zewith/ contained containedin=Comment
syn match Keyword /^# Changes \zsnot staged/ contained containedin=Comment
syn match Keyword /^# \zsUntracked/ contained containedin=Comment
syn match Normal /^#\t\zs[^:]*$/ contained containedin=Comment

syn match DiffAdd    /^#\tnew file:\zs.*/ contained containedin=Comment
syn match DiffDelete /^#\tdeleted:\zs.*/  contained containedin=Comment
syn match Normal     /^#\tmodified:\zs.*/ contained containedin=Comment
syn match Normal     /^#\trenamed:\zs.*/  contained containedin=Comment

syn region Diff start=/^index/ end=/^diff|\%$/
syn match DiffAdd    /^+.*/ contained containedin=Diff
syn match DiffDelete /^-.*/ contained containedin=Diff

setlocal nofoldenable synmaxcol=200
syntax sync minlines=100
