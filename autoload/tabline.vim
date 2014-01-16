" MIT License. Copyright (c) 2013 Bailey Ling.

let s:filetype_symbols = { 'vimfiler': '/', 'help': '?', 'vimshell': '>' }

function! s:Shorten(path, maxlen)
	let path = fnamemodify(a:path, ':~')
	while len(path) > a:maxlen
		let path = substitute(path, '\v[^/]\zs.\ze/|.$', '', '')
	endwhile
	return path . repeat(' ', a:maxlen - len(path))
endfunction

function! airline#extensions#tabline#init(ext)
	autocmd User AirlineToggledOn  call s:toggle_on()
	autocmd User AirlineToggledOff call s:toggle_off()
	call s:toggle_on()

	call a:ext.add_theme_func('airline#extensions#tabline#load_theme')
endfunction

function! s:toggle_off()
	let [ &tabline, &showtabline ] = [ s:original_tabline, s:original_showtabline ]
endfunction

function! s:toggle_on()
	let [ s:original_tabline, s:original_showtabline ] = [ &tabline, &showtabline ]
	set tabline=%!airline#extensions#tabline#get()
	set showtabline=2
	set guioptions-=e
endfunction

function! airline#extensions#tabline#load_theme(palette)
	let colors    = get(a:palette, 'tabline',         {})
	let l:tab     = get(colors,    'airline_tab',     a:palette.normal.airline_b)
	let l:tabsel  = get(colors,    'airline_tabsel',  a:palette.normal.airline_a)
	let l:tabtype = get(colors,    'airline_tabtype', a:palette.visual.airline_a)
	let l:tabfill = get(colors,    'airline_tabfill', a:palette.normal.airline_c)
	let l:tabmod  = get(colors,    'airline_tabmod',  a:palette.insert.airline_a)
	let l:tabhid  = get(colors,    'airline_tabhid',  a:palette.normal.airline_c)

	call airline#highlighter#exec('airline_tab',     l:tab)
	call airline#highlighter#exec('airline_tabsel',  l:tabsel)
	call airline#highlighter#exec('airline_tabtype', l:tabtype)
	call airline#highlighter#exec('airline_tabfill', l:tabfill)
	call airline#highlighter#exec('airline_tabmod',  l:tabmod)
	call airline#highlighter#exec('airline_tabhid',  l:tabhid)
endfunction

function! airline#extensions#tabline#get()
	let b = airline#builder#new({ 'active': 1 })
	for i in range(1, tabpagenr('$'))
		if i == tabpagenr()
			let group = 'airline_tabsel'
			if g:airline_detect_modified
				for bi in tabpagebuflist(i)
					if getbufvar(bi, '&modified')
						let group = 'airline_tabmod'
					endif
				endfor
			endif
		else
			let group = 'airline_tab'
		endif
		let val = '%('
		" let val .= (g:airline_symbols.space).i
		call b.add_section(group, val.'%'.i.'T %{airline#extensions#tabline#title('.i.')} %)')
	endfor

	call b.add_raw('%T')
	call b.add_section('airline_tabfill', '')
	call b.split()
	call b.add_section('airline_tabtype', ' %{strftime("%H:%M")} ')

	return b.build()
endfunction

"set rulerformat=%25(%=%-(:b%-4n0x%-4B%5l,%-4v%P%)%)
"let s  = '%<%{Shorten(bufname(""), 30)} %w%m%r%y%='
"let s .= synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name").'  '
"let s .= &rulerformat

"Set the highlighting and the tab page number (for mouse clicks)
"let s .= '%' . tab . 'T'

"The label itself
"let s .= '['

"let s .= " %{Head('" . dir . "')}"

"function! Head(dir)
"let save = exists('b:git_dir') ? b:git_dir : ''
"let b:git_dir = fugitive#extract_git_dir(a:dir)
"let head = len(b:git_dir) ? fugitive#head(6) : ''
"let b:git_dir = save
"return head
"endfunction

function! airline#extensions#tabline#title(tab)
	let s = '['
	for b in tabpagebuflist(a:tab)
		let s .= get(s:filetype_symbols, getbufvar(b, '&filetype'),
					\ getbufvar(b, '&modified')   ? '!' :
					\ getbufvar(b, '&modifiable') ? '-' : g:airline_symbols.readonly)
	endfor
	let s .= '] '

	return s . s:Shorten(gettabvar(a:tab, 'cwd'), 30 - strlen(s))
endfunction

function! airline#extensions#tabline#get_buffer_name(nr)
	return a:nr . get(s:, 'current_buffer_list', s:get_buffer_list())
endfunction

function! s:get_buffer_list()
	let buffers = []
	let cur = bufnr('%')
	for nr in range(1, bufnr('$'))
		if buflisted(nr) && bufexists(nr)
			for ex in get(g:, 'airline#extensions#tabline#excludes', [])
				if match(bufname(nr), ex)
					continue
				endif
			endfor
			if getbufvar(nr, 'current_syntax') == 'qf'
				continue
			endif
			call add(buffers, nr)
		endif
	endfor

	return buffers
endfunction

function! s:get_visible_buffers()
	let buffers = s:get_buffer_list()
	let cur = bufnr('%')

	let total_width = 0
	let max_width = 0

	for nr in buffers
		let width = len(airline#extensions#tabline#get_buffer_name(nr)) + 4
		let total_width += width
		let max_width = max([max_width, width])
	endfor

	" only show current and surrounding buffers if there are too many buffers
	let position  = index(buffers, cur)
	let vimwidth = &columns
	if total_width > vimwidth && position > -1
		let buf_count = len(buffers)

		" determine how many buffers to show based on the longest buffer width,
		" use one on the right side and put the rest on the left
		let buf_max   = vimwidth / max_width
		let buf_right = 1
		let buf_left  = max([0, buf_max - buf_right])

		let start = max([0, position - buf_left])
		let end   = min([buf_count, position + buf_right])

		" fill up available space on the right
		if position < buf_left
			let end += (buf_left - position)
		endif

		" fill up available space on the left
		if end > buf_count - 1 - buf_right
			let start -= max([0, buf_right - (buf_count - 1 - position)])
		endif

		let buffers = eval('buffers[' . start . ':' . end . ']')

		if start > 0
			call insert(buffers, -1, 0)
		endif

		if end < buf_count - 1
			call add(buffers, -1)
		endif
	endif

	return buffers
endfunction
