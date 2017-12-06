set et ts=2

" silent! syntax include @htmlCss syntax/css.vim
" silent! syntax include @htmlJavascript syntax/js.vim
" silent! syntax include @htmlMarkdown syntax/markdown.vim

syn region  javascriptParenthesisBlock start="(" end=")" contains=@htmlJavascript contained keepend
syn cluster htmlJavascript add=javascriptParenthesisBlock

syn region  pugJavascript matchgroup=pugJavascriptOutputChar start="[!&]\==\|\~" skip=",\s*$" end="$" contained contains=@htmlJavascript keepend
syn region  pugJavascript matchgroup=pugJavascriptChar start="-" skip=",\s*$" end="$" contained contains=@htmlJavascript keepend
syn cluster pugTop contains=pugBegin,pugComment,pugHtmlComment,pugJavascript
syn match   pugBegin "^\s*\%([<>]\|&[^=~ ]\)\@!" nextgroup=pugTag,pugClassChar,pugIdChar,pugPlainChar,pugJavascript,pugScriptConditional,pugScriptStatement,pugPipedText
syn match   pugTag "+\?[[:alnum:]_]\+\%(:\w\+\)\=" contained contains=htmlTagName,htmlSpecialTagName nextgroup=@pugComponent
syn cluster pugComponent contains=pugAttributes,pugIdChar,pugBlockExpansionChar,pugClassChar,pugPlainChar,pugJavascript,pugTagBlockChar,pugTagInlineText
syntax keyword pugCommentTodo  contained TODO FIXME XXX TBD
syn match   pugComment '\(\s\+\|^\)\/\/.*$' contains=pugCommentTodo,@Spell
syn region  pugCommentBlock start="\z(\s\+\|^\)\/\/.*$" end="^\%(\z1\s\|\s*$\)\@!" contains=pugCommentTodo,@Spell keepend
syn region  pugHtmlConditionalComment start="<!--\%(.*\)>" end="<!\%(.*\)-->" contains=pugCommentTodo,@Spell
syn region  pugAngular2 start="(" end=")" contains=htmlEvent
syn region  pugJavascriptString matchgroup=Normal start=+"+  skip=+\\\("\|$\)+  end=+"\|$+ contained
syn region  pugJavascriptString matchgroup=Normal start=+'+  skip=+\\\('\|$\)+  end=+'\|$+ contained
syn region  pugAttributes matchgroup=pugAttributesDelimiter start="(" end=")" contained contains=pugJavascriptString,pugHtmlArg,pugAngular2,htmlArg,htmlEvent,htmlCssDefinition nextgroup=@pugComponent
syn match   pugClassChar "\." containedin=htmlTagName nextgroup=pugClass
syn match   pugBlockExpansionChar ":\s\+" contained nextgroup=pugTag,pugClassChar,pugIdChar
syn match   pugIdChar "#[[{]\@!" contained nextgroup=pugId
syn match   pugClass "\%(\w\|-\)\+" contained nextgroup=@pugComponent
syn match   pugId "\%(\w\|-\)\+" contained nextgroup=@pugComponent
syn region  pugDocType start="^\s*\(!!!\|doctype\)" end="$"
" Unless I'm mistaken, syntax/html.vim requires
" that the = sign be present for these matches.
" This adds the matches back for pug.
syn keyword pugHtmlArg contained href title

syn match   pugPlainChar "\\" contained
syn region  pugInterpolation matchgroup=pugInterpolationDelimiter start="[#!]{" end="}" contains=@htmlJavascript
syn match   pugInterpolationEscape "\\\@<!\%(\\\\\)*\\\%(\\\ze#{\|#\ze{\)"
syn match   pugTagInlineText "\s.*$" contained contains=pugInterpolation,pugTextInlinePug,@Spell
syn region  pugPipedText matchgroup=pugPipeChar start="|" end="$" contained contains=pugInterpolation,pugTextInlinePug nextgroup=pugPipedText skipnl
" syn match   pugTagBlockChar "\.$" contained nextgroup=pugTagBlockText,pugTagBlockEnd skipnl
" syn region  pugTagBlockText start="\%(\s*\)\S" end="\ze\n" contained contains=pugInterpolation,pugTextInlinePug,@Spell nextgroup=pugTagBlockText,pugTagBlockEnd skipnl
" syn region  pugTagBlockEnd start="\s*\S" end="$" contained contains=pugInterpolation,pugTextInlinePug nextgroup=pugBegin skipnl
syn region  pugTextInlinePug matchgroup=pugInlineDelimiter start="#\[" end="]" contains=pugTag keepend

syn region  pugJavascriptFilter matchgroup=pugFilter start="^\z(\s*\):javascript\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlJavascript
syn region  pugMarkdownFilter matchgroup=pugFilter start=/^\z(\s*\):\%(markdown\|marked\)\s*$/ end=/^\%(\z1\s\|\s*$\)\@!/ contains=@htmlMarkdown
syn region  pugStylusFilter matchgroup=pugFilter start="^\z(\s*\):stylus\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlStylus
syn region  pugPlainFilter matchgroup=pugFilter start="^\z(\s*\):\%(sass\|less\|cdata\)\s*$" end="^\%(\z1\s\|\s*$\)\@!"

syn match  pugScriptConditional "^\s*\<\%(if\|else\|else if\|elif\|unless\|while\|until\|case\|when\|default\)\>[?!]\@!"
syn match  pugScriptStatement "^\s*\<\%(each\|for\|block\|prepend\|append\|mixin\|extends\|include\)\>[?!]\@!"
syn region  pugScriptLoopRegion start="^\s*\(for \)" end="$" contains=pugScriptLoopKeywords
syn keyword  pugScriptLoopKeywords for in contained

syn region  pugJavascript start="^\z(\s*\)script\%(:\w\+\)\=" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlJavascript,pugJavascriptTag,pugCoffeescriptFilter keepend 

syn region  pugCoffeescriptFilter matchgroup=pugFilter start="^\z(\s*\):coffee-\?script\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlCoffeescript contained
syn region  pugJavascriptTag contained start="^\z(\s*\)script\%(:\w\+\)\=" end="$" contains=pugBegin,pugTag

syn match  pugError "\$" contained

hi! link pugPlainChar              PreProc
hi! link pugScriptConditional      PreProc
hi! link pugScriptLoopKeywords     PreProc
hi! link pugScriptStatement        PreProc
hi! link pugHtmlArg                Normal
hi! link pugTag                    Keyword
hi! link pugClassChar              Normal
hi! link pugBlockExpansionChar     PreProc
hi! link pugPipeChar               PreProc
hi! link pugJavascriptChar         PreProc
hi! link pugJavascriptOutputChar   PreProc
" hi! link pugTagBlockChar           PreProc
hi! link pugTagInlineText          String
" hi! link pugTagBlockText           String
hi! link pugPipedText              String
hi! link pugIdChar                 Normal
hi! link pugId                     Normal
hi! link pugClass                  Normal
hi! link pugInterpolationDelimiter PreProc
hi! link pugInlineDelimiter        PreProc
hi! link pugFilter                 PreProc
hi! link pugDocType                PreProc
hi! link pugCommentTodo            Todo
hi! link pugComment                Comment
hi! link pugCommentBlock           Comment
hi! link pugHtmlConditionalComment pugComment
hi! link pugJavascriptString       String
