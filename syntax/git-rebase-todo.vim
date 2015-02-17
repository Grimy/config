syn case match
syn match Error /^./
syn match Keyword /\v^%([efprsx]|edit|fixup|pick|reword|squash|exec)>/
syn match Error /\v%^[sf]/
syn match PreProc /\v<\x{7,40}>/ contained
