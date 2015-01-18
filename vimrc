" Copyright © 2014 Grimy <Victor.Adam@derpymail.org> {{{
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

set nocompatible
augroup VimRC
autocmd!

" Utility functions {{{1

function! Map(modes, ...)
	let i = a:1 ==# '<recursive>'
	let lhs = a:000[i]
	let rhs = join(a:000[i+1:])
	let recursive = i || rhs =~ "\<Plug>"

	for mode in split(a:modes, '.\zs')
		execute mode  . (recursive ? 'map' : 'noremap')
					\ (mode =~ '\v[cli]') ? '' : '<silent>'
					\ lhs rhs
	endfor
endfunction
command! -nargs=+ Map call Map(<f-args>)

function! KeepPos(command)
	let save = virtcol('.') - indent('.')
	execute a:command
	execute 'normal! ' . (save + indent('.')) . '|'
endfunction

" Returns the first virtual column of the current character, rather than the last
function! s:VirtCol()
	if col('.') == 1
		return 1
	endif
	normal! h
	let res = virtcol('.') + 1
	normal! l
	return res
endfunction

" Initialization {{{1
if has('vim_starting')
	let s:is_windows = has('win16') || has('win32') || has('win64')

	" Use English messages.
	execute 'language' 'message' s:is_windows ? 'en' : 'C'

	" Keycodes not automatically recognized
	Map clinov <recursive> <C-H> <C-BS>
	Map clinov <recursive> <C-@> <C-Space>
	nmap [3;5~ <C-Del>

	" Vim needs a POSIX-Compliant shell. Fish is not.
	if &shell =~ 'fish'
		set shell=/bin/sh
	endif

	" Useless setting, but the default value can cause a bug in xterm
	let &t_RV='  Howdy!'

	let s:sep        = s:is_windows ? '\' : '/'
	let s:path       = fnamemodify(resolve(expand('<sfile>')), ':p:h') . s:sep
	let s:cache      = s:path . 'cache'  . s:sep
	let &runtimepath = s:path . ',' . s:path . 'bundle' . s:sep . '*'
	let &helpfile    = s:path . 'vimrc'
	" For some reason, vim requires &helpfile to be a valid file, but doesn’t use it

	let &viminfo = '!,%,''42,h,s10,n'  . s:cache . 'info'
	let &directory                     = s:cache . 'swaps'
	let &backupdir                     = s:cache . 'backups'
	let &undodir                       = s:cache . 'undos'
	let g:session                      = s:cache . 'session'

	colorscheme rainbow
endif

" Formatting / encoding {{{1

" Sensible defaults
set incsearch gdefault nojoinspaces

" Patterns are case sensitive iff they contain at least one uppercase
set ignorecase smartcase

" Classic four-spaces wide tab indent
set cindent tabstop=4 shiftwidth=4

" Encoding
set encoding=utf-8
set fileencodings=utf-8,cp1252

" Handle non-ASCII word charcacters
autocmd BufNewFile,BufRead,BufWrite * execute 'setlocal iskeyword+='
				\ . (&fenc == 'utf-8' ? '128-167,224-235' : '192-255')

function! g:SetEncoding(enc)
	if (&fileencoding != a:enc)
		execute 'edit! ++enc=' . a:enc
	endif
endfunction

" History {{{1

" Keep lots of history
set history=100
set hidden
set backup
set noswapfile
set autowrite
set undofile

set sessionoptions=blank,curdir,folds,help,resize,tabpages,winpos
autocmd VimLeave * execute 'mksession!' g:session

" Jump  to  the  last  position  when reopening file
autocmd BufReadPost * silent! normal! g`"zz

" Auto-completion {{{1

" Command-line mode completion
set wildmenu wildmode=longest:full,full wildoptions=tagfile
set showfulltag
set complete=.
set completeopt=longest,menuone

" Key bindings
imap <expr> <Tab>   pumvisible() ? "\<C-N>" : virtcol('.') <= indent('.') + 1 ? "\<C-T>" : ""
imap <expr> <S-Tab> pumvisible() ? "\<C-P>" : virtcol('.') <= indent('.') + 1 ? "\<C-D>" : ""

" GUI options {{{1

" Windows emulation
set keymodel=startsel,stopsel
set selectmode=key,mouse

" Vim feels much more snappy and responsive this way
set nolazyredraw
set cursorline
set synmaxcol=101

if has('gui_running')
	set mouse=ar
	set guioptions=Mc
	set guiheadroom=0
	set nomousefocus
	set mousemodel=popup
	set mousetime=200
	set mouseshape+=v:beam,sd:updown,vd:leftright
	set guicursor+=a:blinkon0 " disable blinking
	set lsp=1 guifont=Input\ Mono\ Compressed\ Medium\ 11
else
	set mouse=nvr
	let &t_SI .= "\<Esc>[6 q"
	let &t_EI .= "\<Esc>[2 q"
endif

" Show matching brackets
set matchpairs+=<:>

" Better replacement characters
set fillchars=stl:\ ,stlnc: ,diff:X,vert:│
set list listchars=tab:»\ ,nbsp:.,precedes:«,extends:»
let &showbreak = '… '
set display=lastline

" Disable trailing whitespace highlighting in insert mode
autocmd InsertEnter * set listchars-=trail:.
autocmd InsertLeave * set listchars+=trail:.

set conceallevel=2
set concealcursor=n

" Don’t break lines in the middle of a word
set linebreak

" The undocumented c flag is vital for completion plugins
set shortmess=tosTacO

" Folding {{{1

" Fold on braces
set foldmethod=marker foldminlines=3 foldnestmax=3 foldlevelstart=0 foldcolumn=0

" Open and close folds smartly
set foldopen=insert,jump,block,hor,mark,percent,quickfix,search,tag,undo
set foldclose=
Map n <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
Map n <expr> l foldclosed(line('.')) != -1 ? 'zv0' : 'l'

Map n zr zR
Map n zm zMzx
Map n [z kzjzkzkzjzxzt
Map n ]z jzkzjzjzkzxzb

" Replacement text for the fold line
function! FoldText()
	let nbLines = v:foldend - v:foldstart
	let line = getline(v:foldstart)
	let line = substitute(line, '^\v\W+|\{+\d*$', '', 'g')
	let space = 72 - strwidth(line . nbLines)
	let line = space < 0 ? line[0:space-3] . '… ' : line . repeat(' ', space)
	return line . printf('(%d lines)', nbLines)
endfunction
set foldtext=FoldText()

" Un clavier azerty en vaut deux ! {{{1

set spelllang=en,fr
set langmap=à@,è`,é~,ç_,’`
lmap à @
lmap è `
lmap é ~
lmap ç _
lmap ’ `

Map clinov <recursive> µ #
Map clinov <recursive> ù %
Map clinov <recursive> § <Bslash>
Map clinov <recursive> ° <Bar>

" Fixes {{{1
" For when vim doesn’t Do What I Mean

" Y yanks until EOL, like D and C
" Default: Y means yy
Map n Y y$

" The cursor can always go over the EOL
" Default: only works if the line is empty
set virtualedit=onemore,block

" g< doesn’t seem to work
Map n g< :set nomore<CR>:messages<CR>:set more

" Arrow keys can cross line borders (but not h and l)
set whichwrap=[,<,>,]

" Escape sequences and insert mode timeout instantly
set notimeout ttimeout timeoutlen=1

" Redo with U
Map n U <C-R>

" Undo/Redo work in visual-mode
Map v u :<Esc>ugv
Map v U :<Esc>Ugv
Map v gu u
Map v gU U

" Backspace can cross line borders
set backspace=indent,eol,start

" - Don’t overwrite registers with single characters
" - Don’t clutter undo history when deleting 0 characters
" - Allow Backspace and Del to wrap in normal mode
Map n x     :<C-U>call DeleteOne(+v:count1, 0)<CR>
Map n X     :<C-U>call DeleteOne(-v:count1, 0)<CR>
Map n <Del> :<C-U>call DeleteOne(+v:count1, 1)<CR>
Map n <BS>  :<C-U>call DeleteOne(-v:count1, 1)<CR>

function! DeleteOne(count, wrap)
	let start = a:count < 0 ? s:VirtCol() + a:count : virtcol('.')
	let end   = a:count < 0 ? s:VirtCol() : virtcol('.') + a:count
	let start = max([start, 1])
	let end   = min([end, virtcol('$')])
	if (start != end)
		execute 'normal! ' . start . '|"_d' . end . '|'
	endif
	if a:wrap && end - start < abs(a:count)
		execute 'normal!' a:count < 0 ? 'kgJ' : 'J'
		call DeleteOne(a:count - abs(a:count) / a:count* (1 + end - start), 1)
	endif
endfunction

" x/X in v-mode doesn’t yank (d/D still does)
Map x x "_d
Map x X "_D

" Control + BS/Del deletes entire words
Map n <nowait> <C-W>        "_db
Map n <C-Del>      "_dw
Map i <C-Del> <C-O>"_dw
Map c <C-Del> <C-\>esubstitute(getcmdline(),'\v%'.getcmdpos().'c.{-}(><Bar>$)\s*','','')<CR>

" Don’t remove indentation when moving
set cpoptions+=I

" Don’t move the cursor when yanking in v-mode
Map x y ygv<Esc>

" Replace relative to the screen (e.g. it takes 4 letters te replace a tab)
Map n R gR
Map n gR R
inoremap <Insert> <C-O>gR

" Vertical movement relative to the screen (matters when 'wrap' is on)
nnoremap <silent> j gj
nnoremap <silent> k gk
noremap <silent> <Down> gj
noremap <silent> <Up>   gk

" Diffs
set diffopt=filler,context:5,foldcolumn:1

" Automatically open the quickfix window when there are errors
autocmd QuickFixCmdPost * cwindow

" Automatically reload file that has changed outside of vim
set autoread

" UNIX shortcuts {{{1

Map clinov <recursive> <C-?> <Backspace>
Map clinov <recursive> <C-B> <Left>
Map clinov <recursive> <C-F> <Right>
Map cliov  <recursive> <C-P> <Up>
Map cliov  <recursive> <C-N> <Down>
Map clinov <recursive> <C-BS> <C-W>

" Ctrl-U: delete to beginning
" Already defined in insert and command modes
nnoremap <C-U> d^
onoremap <C-U>  ^
onoremap <C-U>  ^
" inoremap <C-U> <C-O>d^

" Ctrl-A / Ctrl-E always move to start / end of line, like shells and emacs
" Default: can only be done in command mode with Ctrl-B / Ctrl-E
" Overrides: i_CTRL-A (redo last insert) -- use Ctrl-G instead
" Overrides: c_CTRL-A (list all matches) -- no replacement
" Overrides:   CTRL-A (increment number) -- use Ctrl-S instead
" Overrides: i_CTRL-E (copy from below)  -- use Ctrl-Q instead
" Overrides:   CTRL-E (scroll one down)  -- see scrolling
Map clinov <recursive> <C-A> <Home>
Map clinov <recursive> <C-E> <End>
Map i <Home> <C-O>^

" Ctrl-Q / Ctrl-Y always copy the character above / below the cursor
" Default: can only be done in insert mode with Ctrl-E / Ctrl-Y
" Overrides: i_CTRL-Q (insert verbatim)  -- use Ctrl-V
" Overrides:   CTRL-Y (scroll one up)    -- see scrolling
nnoremap <C-Q> i<C-E><Esc>l
nnoremap <C-Y> i<C-Y><Esc>l
inoremap <C-Q> <C-E>

" Ctrl-T / Ctrl-D always add / remove indent
" Default: only works in insert mode; << and >> behave differently
" Overrides: CTRL-T (pop tag) CTRL-D (scroll half-page down)
Map n <C-T> :call KeepPos('>')<CR>
Map n <C-D> :call KeepPos('<')<CR>
xmap <C-T> VVgv<plug>(dragonfly_right)
xmap <C-D> VVgv<plug>(dragonfly_left)

" Increment / decrement
inoremap <C-S> <C-O><C-A>
inoremap <nowait> <C-X> <C-O><C-X>
nnoremap <C-S> <C-A>

" Mappings galore {{{1

" Auto-escape '/' in search
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" Find and replace
nnoremap s :s:
xnoremap s :s:
nnoremap S :%s:\<<C-R><C-W>\>:
xnoremap S "vy:%s:\V<C-R>v:

" c selects current line, without the line break at the end
onoremap <silent> c :<C-U>normal! ^v$h<CR>

" q selects a comment
Map ox q :<C-U>normal! $[*V]*<CR>

" Common commands with “!”
Map n !b :<C-U>b <C-R>=feedkeys("\t", 't')<CR><BS>
Map n !d :<C-U>!gdb -q -ex 'set confirm off' -ex 'b main' -ex r $(find debug/* -not -name '*.*')<CR>
Map n !e :<C-U>e <C-R>=feedkeys("\t", 't')<CR><BS>
Map n !E :<C-U>e! <C-R>=feedkeys("\t", 't')<CR><BS>
Map n !t :<C-U>tab drop <C-R>=feedkeys("\t", 't')<CR><BS>
Map n !h :<C-U>vert help<C-R>=feedkeys(" ", 't')<CR><BS>
Map n !H :<C-U>read !howdoi<C-R>=feedkeys(" ", 't')<CR><BS>
Map n !q :<C-U>q<CR>
Map n !Q :<C-U>q!<CR>
Map n !l :<C-U>silent grep<C-R>=feedkeys(" ", 't')<CR><BS>
Map n !m :<C-U>make<CR>
Map n !s :<C-U>silent source <C-R>=g:session<CR><CR>
Map n !v :<C-U>vs <C-R>=feedkeys("\t", 't')<CR><BS>
Map n !w :<C-U>w<CR>
Map n !W :<C-U>silent w !sudo tee % >/dev/null<CR>

" Unimpaired-style mappings
nnoremap cod :<C-U>windo set invdiff<CR>
nnoremap con :<C-U>set invnumber<CR>
nnoremap cor :<C-U>set invruler<CR>
nnoremap cos :<C-U>set invspell<CR>
nnoremap cov :<C-U>set virtualedit=block,<C-R>=&ve=~'all'?'onemore':'all'<CR><CR>
nnoremap cow :<C-U>set invwrap<CR>
" TODO : diff markers, lnext, qnext
" \v([<=>])\1{6}

nnoremap yo  :<C-U>set paste<CR>o
nnoremap yp  :<C-U>set paste<CR>a
nnoremap yO  :<C-U>set paste<CR>O
nnoremap yP  :<C-U>set paste<CR>i
autocmd InsertLeave * set nopaste

" Map Q and ; to something useful
Map nx Q gw
Map o  Q ap
Map n  ; .wn

" Preserve CTRL-A
let g:surround_no_insert_mappings = 1
inoremap <nowait> <C-G> <C-A>

" Swap charwise and blockwise visual modes
Map nx v <C-V>
Map nx <C-V> v

" Select the last modified text
nnoremap gc `[v`]

" Always append at the end of the line
Map n a A

" Surely there’s something to do with H, M, - and +

" Plugin config {{{1

Map n _u <C-W>o:UndotreeToggle<CR><C-W>h

vmap <Space>= <Plug>(EasyAlign)
nmap <Space>= <Plug>(EasyAlign)ap

Map n <Space>a :Gcommit --amend<CR>
Map n <Space>b :Gblame<CR>
Map n <Space>c :Gcommit<CR>i
Map n <Space>d <C-W>o:Gdiff<CR><C-W>r
Map n <Space>g :silent Ggrep<C-R>=feedkeys(" ", 't')<CR><BS>
Map n <Space>l :silent Glog<CR>
Map n <Space>p :Gpush<CR>
Map n <Space>s :Gstatus<CR>
Map n <Space>w :Gwrite<CR>

" Eclim
nnoremap <silent> ZI :<C-U>JavaImportOrganize<CR>
nnoremap <silent> ZJ :<C-U>!cd ~/src/drawall/bin && java cc.drawall.ConVector<CR>
nnoremap <silent> ZH :<C-U>JavaCallHierarchy<CR>
nnoremap          ZR :<C-U>JavaRename<Space>
nnoremap <silent> ZP :<C-U>ProjectProblems<CR>
nnoremap <silent> ZO :<C-U>JavaImpl<CR>
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimJavaCallHierarchyDefaultAction = 'vert split'

" NerdCommenter
let g:NERDSpaceDelims = 1
let g:NERDCustomDelimiters = {'vim': {'left': '"'}, 'tup': {'left': '#'}}
inoremap <C-C> <C-O>:call NERDComment('n', 'toggle')<CR>
nnoremap <C-C>      :call NERDComment('n', 'toggle')<CR>j
vnoremap <C-C>      :call NERDComment('v', 'toggle')<CR>gv

" NerdTree
let g:NERDTreeChDirMode = 2
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeWinSize = 42
let g:NERDTreeMinimalUI = 1
nnoremap cd :<C-U>NERDTreeFind<CR>

" YCM
let g:ycm_global_ycm_extra_conf = '~/.vim/scripts/ycm.py'
let g:ycm_always_populate_location_list = 1

" Subliminal
xnoremap <BS>    :SubliminalInsert<CR><BS>
xnoremap <Del>   :SubliminalAppend<CR><Del>
xnoremap <C-U>   :SubliminalInsert<CR><C-U>
xnoremap <C-W>   :SubliminalInsert<CR><C-W>
xnoremap <C-S>   :SubliminalInsert<CR><C-S>
xnoremap <C-X>   :SubliminalInsert<CR><C-X>
xnoremap <C-Del> :SubliminalAppend<CR><C-Del>
xnoremap <C-Y>   :SubliminalInsert<CR><C-Y>
execute "xnoremap <C-Q>   :SubliminalInsert<CR><C-E>"

" Dragonfly
xmap H <Plug>(dragonfly_left)
xmap J <Plug>(dragonfly_down)
xmap K <Plug>(dragonfly_up)
xmap L <Plug>(dragonfly_right)
xmap P <Plug>(dragonfly_copy)

" xmledit
let g:xmledit_enable_html = 1
let g:xml_use_xhtml = 1

" Pylint
let g:pymode_rope             = 0
let g:pymode_lint_signs       = 0
let g:pymode_lint_checker     = "pyflakes,pep8,pylint"
let g:pymode_lint_ignore      = "W191,E501,C0110,C0111,E223,E302,E126,W0312,C901"
let g:pymode_syntax_slow_sync = 0
let g:pymode_folding          = 0
Map n <Esc> :<C-U>lclose<Bar>pclose<Bar>cclose<Bar>set cmdheight=2 cmdheight=1<CR>

" Managing multiple windows / tabs {{{1

" Minimize clutter
set showtabline=0 laststatus=0 showcmd
set ruler rulerformat=%42(%=%m%f\ %-(#%-2B%5l,%-4v%P%)%)

" Geometry
set splitright splitbelow
set noequalalways
set winwidth=88
set previewheight=16
set winminwidth=6

autocmd BufHidden * if winnr('$') == 1 && (&diff || !len(expand('%'))) | q | endif

" Use Tab to switch between windows
Map n <Tab>   <C-W>w
Map n <S-Tab> <C-W>W

" gy is easier to type than gT
nnoremap gy gT

" Control-Tab is nice and consistent with browsers, but only works in the GUI
Map n <C-Tab>   gt
Map n <C-S-Tab> gT

" Restore <C-W>
nnoremap <expr> L "\<C-W>" . nr2char(getchar())

execute 'cd' expand('%:p:h')

" Scrolling {{{1

" Keep a few lines/columns around the cursor
set scrolljump=4 scrolloff=20
set sidescroll=2 sidescrolloff=8

" Keep cursor column when scrolling
set nostartofline
Map nov gg gg0
Map nov G  G$l

function! Scroll(lines, up)
	let lines = v:count1 * a:lines
	if mode() =~ "[iR]"
		return repeat("\<C-X>" . (a:up ? "\<C-Y>" : "\<C-E>"), lines)
	endif
	return v:count1 * a:lines . (a:up ? "\<C-U>" : "\<C-D>")
endfunction

" Mouse scrolls the cursor
Map nvi <expr> <ScrollWheelDown> Scroll(4, 0)
Map nvi <expr> <ScrollWheelUp>   Scroll(4, 1)
Map nv  <expr> <C-J>             Scroll(12, 0)
Map nv  <expr> <C-K>             Scroll(12, 1)
" Map nv  <expr> <Space>           Scroll(&lines-5, 0)
" Map nv  <expr> <S-Space>         Scroll(&lines-5, 1)
Map nvi <expr> <PageDown>        Scroll(&lines-5, 0)
Map nvi <expr> <PageUp>          Scroll(&lines-5, 1)

Map c <C-J> <Down>
Map c <C-K> <Up>

autocmd InsertEnter * let g:last_insert_col = virtcol('.')
Map i <expr> <C-J> "\<Esc>j" . g:last_insert_col . "\<Bar>i"
Map i <expr> <C-K> "\<Esc>k" . g:last_insert_col . "\<Bar>i"

" Pasting {{{1

" Emulate xterm behaviour
Map clinov <S-Insert> <MiddleMouse>

set clipboard=unnamed
lnoremap <C-R> <C-R><C-P>

" After a paste, leave the cursor at the end and fix indent
function! ConditionalPaste(invert, where)
	let [text, type] = [getreg(), getregtype()]
	if a:invert
		let type = type ==# 'v' ? 'V' : 'v'
		if type ==# 'v'
			let text = substitute(text, '\v(^|\n)\s*', ' ', 'g')
		endif
		call setreg(v:register, text, type)
	endif
	let sequence = a:where . (type ==# 'V' ? '`[v`]=`]$' : '')
	execute 'normal!' sequence
	call repeat#set(sequence)
	let g:repeat_reg = [sequence, v:register]
endfunction

nnoremap <silent> p  :call ConditionalPaste(0, 'p')<CR>
nnoremap <silent> P  :call ConditionalPaste(0, 'P')<CR>
nnoremap <silent> cp :call ConditionalPaste(1, 'p')<CR>
nnoremap <silent> cP :call ConditionalPaste(1, 'P')<CR>

" Experimental {{{1

set suffixes+=.class

nnoremap <C-N> <C-I>
nnoremap <C-P> :<C-P>
Map nv   <C-G> ".P
Map c    <C-G> <C-R>.

" Golf
autocmd BufWritePost ~/Golf/** !cat %.in 2>/dev/null | perl5.8.8 %
autocmd BufReadPost,BufEnter ~/Golf/** setlocal bin noeol filetype=perl

" ag
set grepprg=ag

" YCM
let g:ycm_seed_identifiers_with_syntax = 1

" Syntax file debugging
nnoremap ,, :echo "hi<" . synIDattr(synID(line("."), col("."), 1), "name") . '> trans<'
			\ . synIDattr(synID(line("."), col("."), 0), "name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"<CR>
