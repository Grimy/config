Comments //
Flow if|for|switch|try|while|with else|case|catch

syntax keyword Flow throw continue break
syntax keyword Keyword abstract arguments boolean byte char class const debugger
syntax keyword Keyword default delete do double enum eval export extends false final
syntax keyword Keyword finally float function goto implements import in instanceof
syntax keyword Keyword int interface let long native new null package private
syntax keyword Keyword protected public return short static super synchronized this
syntax keyword Keyword throws transient true typeof var void volatile yield

syn region String matchgroup=Normal start=/\v\z(['"])/ end=/\z1/ contains=SpecialChar
syn region Comment start='\V/*' end='\V*/'
syn match SpecialChar /\v\\(v|x\x{1,2}|u\x{4})/ contained
