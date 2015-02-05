call g:SetupVinegar()
silent! call netrw#LocalBrowseCheck(expand('%'))
let &l:filetype='netrw'
