" Common syntax
syn keyword Todo TODO contained containedin=Comment

let s:seps = split(&commentstring, '\s*%s\s*')
let s:seps[0] = (len(s:seps[0]) == 1 ? '\^\s\*' : '') . s:seps[0]
execute 'syn region Comment start=_\V' . s:seps[0] . '_ end=_\V' . get(s:seps, 1, '\$') . '_'

syn match SpecialChar /\v\\([bfnrt\\"]|\o{1,3})/ contained
hi! link ErrorChar Error

" See fo-table
setlocal formatoptions=croqljn
setlocal nrformats-=octal
setlocal comments=sr:/**,mb:*,ex:*/,sr:/*,mb:*,ex:*/
setlocal autoindent

" Annoying mappings
silent! vunmap <buffer> K

" Indenting!
set indentexpr=Indent()
set indentkeys=0),0},0],o,O,=end,=else,=elsif,=when,=ensure,=rescue,=begin,=end
let &indentkeys .= ',0\,0+,0-,0*,0/,0%,0&,0|,0&,0~,0<!>,0?,0:,0<<>,0=,0<>>,0,'
function! Indent() abort
	let line = line('.') - 1
	while empty(getline(line)) && line > 1
		let line -= 1
	endwhile
	return indent(line) + float2nr(&ts * BonusIndent(getline(line), getline('.')))
endfunction
