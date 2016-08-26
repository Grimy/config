Comments [ ]

syn match Todo /\v^%(Book|Chapter|Volume|Section)>.*/
syn region String matchgroup=Normal start='"' end='"'
syn region PreProc start='\[' end='\]' contained containedin=String
