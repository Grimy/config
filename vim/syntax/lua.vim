Comments --
Flow function|if|for|while|do|repeat else|elseif end|until braces

syn keyword Flow then return and or break
syn region String matchgroup=Normal start=/\v\z(['"])/ end=/\v\z1/ contains=SpecialChar
syn match SpecialChar /\v\\([av']|x\x{1,2})/ contained
syn region Comment start='\V--[[' end='\V]]'

let b:indent_start .= '|<function>'
setlocal makeprg=luajit-vim\ %
setlocal errorformat=luajit:\ %f:%l:%m
