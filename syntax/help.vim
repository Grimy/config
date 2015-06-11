" Follow tags with Return
Map n <buffer> K <C-]>
Map n <buffer> <CR> <C-]>
setlocal iskeyword+=:,#
autocmd BufEnter <buffer> set scrolloff=999 scrolljump=1
autocmd BufLeave <buffer> set scrolloff=20  scrolljump=4

" TODO: refactor
syn region helpExample  matchgroup=helpIgnore start=" >$" start="^>$" end="^[^ \t]"me=e-1 end="^<" concealends
syn keyword helpNote    note Note NOTE note: Note: NOTE: Notes Notes:
syn match helpHeadline          "^[-A-Z .][-A-Z0-9 .()]*[ \t]\+\*"me=e-1
syn match helpSectionDelim      "^===.*===$"
syn match helpSectionDelim      "^---.*--$"
syn match helpHyperTextJump     "\\\@<!|[#-)!+-~]\+|" contains=helpBar
syn match helpHyperTextEntry    "\*[#-)!+-~]\+\*\s"he=e-1 contains=helpStar
syn match helpHyperTextEntry    "\*[#-)!+-~]\+\*$" contains=helpStar
syn match helpBar               contained "|" conceal
syn match helpBacktick          contained "`" conceal
syn match helpStar              contained "\*" conceal
syn match helpNormal            "|.*====*|"
syn match helpNormal            "|||"
syn match helpNormal            ":|vim:|"       " for :help modeline
syn match helpVim               "\<Vim version [0-9][0-9.a-z]*"
syn match helpVim               "VIM REFERENCE.*"
syn match helpVim               "\<Nvim\."
syn match helpVim               "NVIM REFERENCE.*"
syn match helpOption            "'[a-z]\{2,\}'"
syn match helpOption            "'t_..'"
syn match helpCommand           "`[^` \t]\+`"hs=s+1,he=e-1 contains=helpBacktick
syn match helpHeader            "\s*\zs.\{-}\ze\s\=\~$" nextgroup=helpIgnore
syn match helpGraphic           ".* \ze`$" nextgroup=helpIgnore
syn match helpIgnore            "." contained conceal
syn match helpSpecial           "\<N\>"
syn match helpSpecial           "\<N\.$"me=e-1
syn match helpSpecial           "\<N\.\s"me=e-2
syn match helpSpecial           "(N\>"ms=s+1
syn match helpSpecial           "\[N]"
syn match helpSpecial           "N  N"he=s+1
syn match helpSpecial           "Nth"me=e-2
syn match helpSpecial           "N-1"me=e-2
syn match helpSpecial           "{[-a-zA-Z0-9'"*+/:%#=[\]<>.,]\+}"
syn match helpSpecial           "\s\[[-a-z^A-Z0-9_]\{2,}]"ms=s+1
syn match helpSpecial           "<[-a-zA-Z0-9_]\+>"
syn match helpSpecial           "<[SCM]-.>"
syn match helpNormal            "<---*>"
syn match helpSpecial           "\[range]"
syn match helpSpecial           "\[line]"
syn match helpSpecial           "\[count]"
syn match helpSpecial           "\[offset]"
syn match helpSpecial           "\[cmd]"
syn match helpSpecial           "\[num]"
syn match helpSpecial           "\[+num]"
syn match helpSpecial           "\[-num]"
syn match helpSpecial           "\[+cmd]"
syn match helpSpecial           "\[++opt]"
syn match helpSpecial           "\[arg]"
syn match helpSpecial           "\[arguments]"
syn match helpSpecial           "\[ident]"
syn match helpSpecial           "\[addr]"
syn match helpSpecial           "\[group]"
syn match helpSpecial           "CTRL-."
syn match helpSpecial           "CTRL-Break"
syn match helpSpecial           "CTRL-PageUp"
syn match helpSpecial           "CTRL-PageDown"
syn match helpSpecial           "CTRL-Insert"
syn match helpSpecial           "CTRL-Del"
syn match helpSpecial           "CTRL-{char}"
syn match helpLeadBlank         "^\s\+" contained
syn match helpURL               `\v<[a-z]+://[^' <>"]+`

hi def link helpIgnore          Ignore
hi def link helpHyperTextJump   String
hi def link helpBar             Ignore
hi def link helpBacktick        Ignore
hi def link helpStar            Ignore
hi def link helpHyperTextEntry  String
hi def link helpHeadline        Statement
hi def link helpHeader          PreProc
hi def link helpSectionDelim    PreProc
hi def link helpVim             Identifier
hi def link helpCommand         Comment
hi def link helpExample         Comment
hi def link helpOption          Type
hi def link helpNotVi           Special
hi def link helpSpecial         Special
hi def link helpNote            Todo
hi def link helpComment         Comment
hi def link helpConstant        Constant
hi def link helpString          String
hi def link helpCharacter       Character
hi def link helpNumber          Number
hi def link helpBoolean         Boolean
hi def link helpFloat           Float
hi def link helpIdentifier      Identifier
hi def link helpFunction        Function
hi def link helpStatement       Statement
hi def link helpConditional     Conditional
hi def link helpRepeat          Repeat
hi def link helpLabel           Label
hi def link helpOperator        Operator
hi def link helpKeyword         Keyword
hi def link helpException       Exception
hi def link helpPreProc         PreProc
hi def link helpInclude         Include
hi def link helpDefine          Define
hi def link helpMacro           Macro
hi def link helpPreCondit       PreCondit
hi def link helpType            Type
hi def link helpStorageClass    StorageClass
hi def link helpStructure       Structure
hi def link helpTypedef         Typedef
hi def link helpSpecialChar     SpecialChar
hi def link helpTag             Tag
hi def link helpDelimiter       Delimiter
hi def link helpSpecialComment  SpecialComment
hi def link helpDebug           Debug
hi def link helpUnderlined      Underlined
hi def link helpError           Error
hi def link helpTodo            Todo
hi def link helpURL             String
