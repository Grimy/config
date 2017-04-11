Flow if|IF else|ELSE|elseif|ELSEIF endif|ENDIF
Comments #

syn match Keyword /\v<qi_\k+/
syn region Normal matchgroup=PreProc start=/\${/ end=/}/

setl ts=4
