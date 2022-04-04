Comments '
Flow Class|Method|Function|For|While|If Else|Elseif|ElseIf End|Endif|EndIf|Wend|Next braces

syn keyword Flow Return And Or Import Strict
syn region String matchgroup=Normal start=/\v\z(")/ end=/\v\\?\z1/ contains=SpecialChar
syn match SpecialChar /\v\\([av']|x\x{1,2})/ contained
syn region Comment start=/#rem/ end=/#End/
