" Smart indent detection
let &l:expandtab = getline(search('^%(\t|  )', 'wn'))[0] == ' '

" Handle non-ASCII word charcacters
execute 'setlocal iskeyword+=' . (&fenc == 'utf-8' ? '128-167,224-235' : '192-255')

" Common syntax
syntax sync minlines=42
syn keyword Todo TODO contained containedin=Comment

let s:seps = split(&commentstring, '\s*%s\s*')
let s:seps[0] = (len(s:seps[0]) == 1 ? '\^\s\*' : '') . s:seps[0]
execute 'syn region Comment start=_\V' . s:seps[0] . '_ end=_\V' . get(s:seps, 1, '\$') . '_'

syn match SpecialChar /\v\\([bfnrt\\"]|\o{1,3})/ contained

" See fo-table
setlocal formatoptions=croqljn
setlocal nrformats-=octal
setlocal comments=sr:/**,mb:*,ex:*/,sr:/*,mb:*,ex:*/
setlocal autoindent

" Indenting!
set indentexpr=Indent()
set indentkeys=0),0},0],o,O,=end,=else,=elsif,=when,=ensure,=rescue,=begin,=endif,=endfor,=enwhile,=endfunction
let &indentkeys .= ',0\,0+,0-,0*,0%,0&,0|,0&,0~,0<!>,0?,0:,0<<>,0=,0<>>,0,'

let b:indent_start  = get(b:, 'indent_start', '{\s*$')
let b:indent_end    = get(b:, 'indent_end', '^\s*}')
let b:indent_cont   = get(b:, 'indent_cont', '\v$.')
let b:indent_conted = get(b:, 'indent_conted', '\v[(,]$')

function! Indent() abort
	let line = line('.') - 1
	while empty(getline(line)) && line > 0
		let line -= 1
	endwhile
	if line == 0
		return 0
	endif
	let indent = indent(line)
	let prev = getline(line)
	let cur = getline('.')
	if (&commentstring == '// %s')
		if cur =~# '\v^\s*/\*'
			let indent -= &ts
		endif
		if prev =~# '\v^\s*/\*'
			let indent += 1 + (prev =~# '\v^\s*/\*\*')
		endif
		if prev =~# '\v\*/$'
			let indent += &ts
			let indent -= indent % &ts
		endif
	endif
	return indent + &ts * ((prev =~ b:indent_start) - (cur =~ b:indent_end)
		\ + (cur =~# b:indent_cont || prev =~# b:indent_conted)
		\ - (prev =~# b:indent_cont || getline(line - 1) =~# b:indent_conted))
endfunction

set conceallevel=1 concealcursor+=i
syntax match Operator '<=' conceal cchar=≤
syntax match Operator '>=' conceal cchar=≥
syntax match Operator '::' conceal cchar=∷
