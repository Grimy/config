syntax keyword Keyword abstract arguments boolean break byte
syntax keyword Keyword case catch char class const
syntax keyword Keyword continue debugger default delete do
syntax keyword Keyword double else enum eval export
syntax keyword Keyword extends false final finally float
syntax keyword Keyword for function goto if implements
syntax keyword Keyword import in instanceof int interface
syntax keyword Keyword let long native new null
syntax keyword Keyword package private protected public return
syntax keyword Keyword short static super switch synchronized
syntax keyword Keyword this throw throws transient true
syntax keyword Keyword try typeof var void volatile
syntax keyword Keyword while with yield

syn region String matchgroup=Normal start=/\v\z(['"])/ end=/\z1/ contains=SpecialChar
syn region Comment start='\V/*' end='\V*/'
syn match SpecialChar /\v\\(v|x\x{1,2}|u\x{4})/ contained
let &l:commentstring = '// %s'
