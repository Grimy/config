Flow if|for|while|match|loop else
Comments //

syn region Comment start='\V/*' end='\V*/'

syn keyword Error alignof become do offsetof priv pure sizeof typeof unsized
syn keyword Error yield abstract virtual final override macro once
syn keyword Flow in break continue return
syn keyword Keyword as box extern fn pub impl let unsafe where super self
syn keyword Keyword mod trait struct enum move mut ref static const true false
syn keyword Type isize usize char bool u8 u16 u32 u64 f32
syn keyword Type f64 i8 i16 i32 i64 str Self
syn keyword PreProc use crate

syn match PreProc '\w\(\w\)*!'
syn match PreProc '#\w\(\w\)*' contains=rustAssert,rustPanic

syn region Character matchgroup=Normal start=/\vb?'/ end=/'/ contains=SpecialChar,ErrorChar oneline
syn region String    matchgroup=Normal start=/\vb?"/ end=/"/ contains=SpecialChar,ErrorChar oneline
syn region String    matchgroup=Normal start=/\vb?r\z(#*)"/ end=/"\z1/ contains=SpecialChar,ErrorChar oneline
syn match SpecialChar /\v\\('|x\x{2}|u\x{4}|u\{\x{1,6}\}|U\x{8})/

syn region rustBoxPlacement matchgroup=rustBoxPlacementParens start="(" end=")" contains=TOP contained
syn region rustBoxPlacementBalance start="(" end=")" containedin=rustBoxPlacement transparent
syn region rustBoxPlacementBalance start=/\[/ end=/\]/ containedin=rustBoxPlacement transparent
syn region rustMacroRepeat matchgroup=rustMacroRepeatDelimiters start="$(" end=")" contains=TOP nextgroup=rustMacroRepeatCount
syn match rustMacroRepeatCount /.\?[*+]/ contained
syn match rustMacroVariable /$\w\+/

syn region PreProc start=/\v#!?\[/ end=/\v\]/ contains=rustDerive
syn region rustDerive start="derive(" end=")" contained contains=rustDeriveTrait
syn keyword rustDeriveTrait contained Clone Hash RustcEncodable RustcDecodable PartialEq Eq PartialOrd Ord Rand Debug Default FromPrimitive Send Sync Copy
