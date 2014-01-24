" Copyright © 2014 Grimy <Victor.Adam@derpymail.org>
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

" Utility functions {{{

function! GetChar(...)
	let char = a:0 ? getchar(a:1) : getchar()
	return char > 0 ? nr2char(char) : char
endfunction

function! Map(modes, ...)
	let flags = { 'nosilent': 0, 'recursive': 0 }
	let i = 0

	while a:000[i] =~ '\v\C^\<(nosilent|recursive)\>$'
		let flags[a:000[i][1:-2]] = 1
		let i = i + 1
	endwhile

	let lhs = a:000[i]
	let rhs = join(a:000[i+1:])
	let flags['recursive'] += rhs =~ "\<Plug>"

	for mode in split(a:modes, '.\zs')
		execute mode  . (flags['recursive'] ? 'map' : 'noremap')
					\ (mode =~ '\v[cli]') || flags['nosilent'] ? '' : '<silent>'
					\ lhs rhs
	endfor
endfunction
command! -nargs=+ Map call Map(<f-args>)

" }}}

" Initialization {{{
if has('vim_starting')

	" Environment detection {{{

	let s:is_windows = has('win16') || has('win32') || has('win64')

	" Use English messages.
	execute 'language' 'message' s:is_windows ? 'en' : 'C'

	" Keycodes not automaitcally recognized
	Map clinov <recursive> <C-?> <C-BS>
	Map clinov <recursive> <C-@> <C-Space>

	" Disable the annoying beep when pressing Esc twice
	Map n <Esc> <Nop>

	" Vim needs a POSIX-Compliant shell. Fish is not.
	if &shell =~ 'fish'
		set shell=/bin/sh
	endif

	" Useless setting, but the default value can cause a bug in xterm
	let &t_RV='  Howdy ' . $USERNAME . '!'

	" }}}

	" Manage paths {{{
	let s:sep     = s:is_windows ? '\' : '/'
	let s:path    = fnamemodify(resolve(expand('<sfile>')), ':p:h') . s:sep
	let s:cache   = s:path . 'cache'  . s:sep
	let s:bundle  = s:path . 'bundle' . s:sep
	let &helpfile = s:path . 'vimrc'
	" For some reason, vim requires &helpfile to be a valid file, but doesn’t use it

	let &viminfo = '!,%,''42,h,s10,n'  . s:cache . 'info'
	let &directory                     = s:cache . 'swaps'
	let &backupdir                     = s:cache . 'backups'
	let &undodir                       = s:cache . 'undos'
	let g:session                      = s:cache . 'session'
	let g:neocomplete#data_directory   = s:cache . 'neocomplete'
	let g:vimfiler_data_directory      = s:cache . 'vimfiler'
	let g:vimshell_temporary_directory = s:cache . 'vimshell'
	let g:unite_data_directory         = s:cache . 'unite'
	let &runtimepath = s:path . ',' . s:bundle . 'neobundle.vim'
	" }}}

	" NeoBundle {{{

	" Initialization
	call neobundle#rc(s:bundle)
	NeoBundleFetch 'Shougo/neobundle.vim'
	NeoBundle 'Grimy/vim-default-runtime'

	" Syntax coloring
	NeoBundle 'Grimy/vim-rainbow'
	NeoBundle 'dag/vim-fish'
	NeoBundle 'bling/vim-airline'

	" File management
	NeoBundle 'Shougo/vimproc', { 'build' : {
				\     'windows': 'make -f make_mingw32.mak',
				\     'cygwin':  'make -f make_cygwin.mak',
				\     'mac':     'make -f make_mac.mak',
				\     'unix':    'make -f make_unix.mak',
				\ }}

	NeoBundle 'Shougo/unite.vim'
	NeoBundle 'Shougo/unite-ssh'

	NeoBundleLazy 'osyo-manga/unite-quickfix',
				\ { 'unite_sources' : 'quickfix' }
	NeoBundleLazy 'Shougo/unite-help',
				\ { 'unite_sources' : 'help' }
	NeoBundleLazy 'tsukkee/unite-tag',
				\ { 'unite_sources' : ['tag', 'tag/include', 'tag/file'] }
	NeoBundleLazy 'thinca/vim-unite-history',
				\ { 'unite_sources' : ['history/command', 'history/search'] }
	NeoBundle 'Shougo/unite-outline',
				\ { 'unite_sources' : 'outline' }

	NeoBundle 'Shougo/vimfiler'
	NeoBundle 'Shougo/vimshell'
	NeoBundle 'ujihisa/vimshell-ssh'
	NeoBundle 'tyru/open-browser.vim'
	NeoBundle 'tpope/vim-afterimage'

	" Editing functionnality
	NeoBundle 'vim-scripts/UnconditionalPaste'
	NeoBundle 'tpope/vim-surround'
	NeoBundle 'tpope/vim-unimpaired'
	NeoBundle 'scrooloose/nerdcommenter'
	NeoBundle 'godlygeek/tabular'
	NeoBundle 'sukima/xmledit'
	NeoBundle 'Grimy/dragonfly'
	NeoBundle 'Grimy/subliminal'
	NeoBundle 'tpope/vim-endwise'
	NeoBundle 'Grimy/indextrous'

	"Git power
	NeoBundle 'tpope/vim-fugitive'
	NeoBundle 'tomtom/quickfixsigns_vim'

	" Completion
	NeoBundle 'tomtom/tlib_vim'
	NeoBundle 'Shougo/neocomplete'
	NeoBundle 'Shougo/neosnippet'
	NeoBundle 'Shougo/neosnippet-snippets'
	NeoBundle 'mmorearty/vim-matchit'
	NeoBundle 'mbbill/undotree'
	NeoBundle 'tpope/vim-endwise'

	" For testing purposes
	NeoBundle 'joedicastro/vim-multiple-cursors'
	NeoBundle 'vim-scripts/foldsearch'
	NeoBundle 'ujihisa/shadow.vim'

	" Check
	NeoBundleCheck
	" }}}

endif
" }}}

" Formatting / encoding {{{

" Show search results as you type
set incsearch

" Patterns are case sensitive iff they contain at least one uppercase
set ignorecase smartcase

set cindent      " Not actually C-specific

set tabstop=4    " One indenting level = 4 spaces
set shiftwidth=4 " One tab = 4 spaces

set smarttab     " Backspace at the beginning of a line deletes 4 spaces
set nojoinspaces " Only one space between sentences

" Encoding
set encoding=utf-8
set fileencodings=utf-8,cp1252

" Handle non-ASCII word charcacters
augroup SetEncoding
	autocmd!
	autocmd BufNewFile,BufRead,BufWrite * execute 'setlocal iskeyword+='
				\ . (&fenc == 'utf-8' ? '128-167,224-235' : '192-255')
augroup END

function! g:SetEncoding(enc)
	if (&fileencoding != a:enc)
		execute 'edit! ++enc=' . a:enc
	endif
endfunction

" }}}

" History {{{

" Keep lots of history
set history=100
set hidden
set backup
set undofile undolevels=65536
set autowrite

augroup AutomaticSwapRecoveryAndDelete
	autocmd!
	autocmd WinEnter * checktime
	autocmd SwapExists  * let v:swapchoice = 'r'
				\ | let b:swapname = v:swapname
	autocmd BufWinEnter * if exists('b:swapname')
				\ | call delete(b:swapname)
				\ | unlet b:swapname
				\ | endif
augroup END


set sessionoptions=blank,curdir,folds,help,resize,tabpages,winpos,winsize
autocmd VimLeave * execute 'mksession!' g:session
Map n !s :silent source <C-R>=g:session<CR><CR>

" Jump  to  the  last  position  when reopening file
augroup RecoverLastPosition
	autocmd!
	autocmd BufReadPost * silent! normal! g`"zz
augroup END

" }}}

" Better macros {{{

" Allows mapping q<Anything> without introducing a delay when
" stopping the recording of a macro
Map n <expr> q HandleQ()

let g:recording = 'q'

function! HandleQ()
	if &cmdheight == 1
		let reg = GetChar()
		if (reg =~ '\v[0-9a-zA-Z"]')
			" Valid register
			let g:recording = reg
			set cmdheight=2
			return 'q' . g:recording
		endif
		return get(s:qmap, reg, "\<Esc>")
	else
		set cmdheight=1
		return 'q'
	endif
endfunction

" Common typo, q: for :q
let s:qmap = { ':': ':q' }

" @@ executes the last recorded macro
Map n <expr> @@ '@' . g:recording

" }}}

" Auto-completion {{{

" Options for the default completion
set wildmenu
set wildmode=longest:full,full
set wildoptions=tagfile
set showfulltag
set complete=.
set completeopt=preview,longest,menuone

" Disables the default completion
Map i <expr> <C-P> pumvisible() ? "\<C-P>" : "\<Up>"
Map i <expr> <C-N> pumvisible() ? "\<C-N>" : "\<Down>"

" Neocomplete!
let g:neocomplete#enable_at_startup            = 1
let g:neocomplete#enable_smart_case            = 1
let g:neocomplete#max_list                     = 8
let g:neocomplete#auto_completion_start_length = 1
let g:neocomplete#enable_auto_delimiter        = 1
let g:neocomplete#enable_fuzzy_completion      = 0
augroup NeoCompleteConfig
	autocmd!
	autocmd InsertLeave * NeoSnippetClearMarkers
augroup END

" Key bindings
Map i <recursive> <expr> <Tab>     MyTab(0)
Map i <recursive> <expr> <S-Tab>   MyTab(1)
Map i <expr> <C-Space> neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
			\                                : "\<Plug>(neosnippet_expand)"

" Don’t slow down movements with lots of popups
Map i <expr> <Left>  neocomplete#close_popup() . "\<Left>"
Map i <expr> <Right> neocomplete#close_popup() . "\<Right>"
Map i <expr> <Up>    neocomplete#close_popup() . "\<Up>"
Map i <expr> <Down>  neocomplete#close_popup() . "\<Down>"
Map i <expr> <BS>    neocomplete#smart_close_popup() . "\<BS>"

function! MyTab(shift)
	if pumvisible()
		return a:shift ? "\<C-P>" : "\<C-N>"
	elseif neosnippet#jumpable()
		return "\<Plug>(neosnippet_jump)"
	elseif neosnippet#expandable()
		return "\<Plug>(neosnippet_expand)"
	elseif virtcol('.') <= indent('.') + 1
		return a:shift ? "\<C-D>" : "\<C-T>"
	endif
	return ""
endfunction

" }}}

" GUI options {{{

" Windows emulation
set keymodel=startsel,stopsel
set selection=exclusive
set selectmode=key,mouse

" Vim feels much more snappy and responsive this way
set lazyredraw
set cursorline

if has('gui_running')
	set mouse=ar

	set guioptions=Mc
	set guiheadroom=0
	set nomousefocus
	set mousemodel=popup
	set mousetime=200
	set mouseshape+=v:beam,sd:updown,vd:leftright
	set guicursor+=a:blinkon0 " disable blinking

	" Change font size easily
	function! FontSize(d)
		let &guifont= substitute(&guifont, '\d\+',
					\ '\=eval(submatch(0)' . a:d . ')', '')
		set lines=56 columns=999
		return ''
	endfunction

	Map clinov <expr> <C-ScrollWheelUp>   FontSize('+1')
	Map clinov <expr> <C-ScrollWheelDown> FontSize('-1')
	Map n cof :set guifont=*<CR>

	if has('vim_starting')
		set lsp=-2 guifont=Inconsolata\ 11
		set lsp=-2 guifont=Droid\ Sans\ Mono\ for\ Powerline\ 11
		set lsp=-2 guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 11
		set lsp=0  guifont=Liberation\ Mono\ for\ Powerline\ 11
		" $@[]{}()|\/ blah/fox Illegal10Oo :;MH,.!?&=+-

		" Because coding on a white background is an heresy
		set background=dark
		colorscheme solarized

	endif
else
	set mouse=nvr  " Disable the mouse in insert mode
	let &t_SI .= "\<Esc>[6 q"
	let &t_EI .= "\<Esc>[2 q"
	colorscheme rainbow
endif

"syntax match SpecialKey '^\s\+' containedin=ALL
"match Error /\%>80v.*/

" Show matching brackets
set matchpairs+=<:>

" Better replacement characters
set fillchars=stl:\ ,stlnc:\ ,diff:X
set list listchars=tab:»\ ,nbsp:␣,precedes:«,extends:»
set display=lastline  " don’t replace the last line with @’s

let &showbreak                    = '↩ '
let g:unite_prompt                = '» '
let g:unite_marked_icon           = '✓'
let g:vimfiler_marked_file_icon   = '✓'
let g:vimfiler_tree_leaf_icon     = '│'
let g:vimfiler_tree_opened_icon   = '▾'
let g:vimfiler_tree_closed_icon   = '▸'
let g:vimfiler_file_icon          = ' '
let g:vimfiler_readonly_file_icon = ''

set conceallevel=2
set concealcursor=n

" Showing trailing whitespace is great, but it shows whenever you append
" a space
" The workaround is to disable it in insert mode
augroup ShowTrailingSpaces
	autocmd!
	autocmd InsertEnter * set listchars-=trail:␣
	autocmd InsertLeave * set listchars+=trail:␣
augroup END

" Don’t break lines in the middle of a word
set linebreak

" Show (partial) command in status line
set showcmd
set shortmess=atToO

" }}}

" Folding {{{

" Fold on braces
set foldmethod=marker
set foldminlines=3
set foldnestmax=3
set foldlevelstart=0
set foldcolumn=0

" Open and close folds smartly
set foldopen+=insert,jump
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zv0' : 'l'
Map n zr zR
Map n zm zM

" Replacement text for the fold line
function! FoldText()
	let nbLines = v:foldend - v:foldstart
	let line = getline(v:foldstart)
	let line = substitute(line, '^\v\W+|\W+$', '', 'g')
	let space = 66 - strlen(line)
	let line = space < 0 ? line[0:space-3] . '… ' : line . repeat(' ', space)
	return line . printf('%6s lines)', '(' . nbLines)
endfunction
set foldtext=FoldText()

" }}}

" Un clavier azerty en vaut deux ! {{{

set spelllang=en,fr

set langmap=à@,è`,é~,ç_,ù%
Map l <recursive> à @
Map l <recursive> è `
Map l <recursive> é ~
Map l <recursive> ç _
Map l <recursive> ù %
Map l <recursive> ’ '

" ¨ and £ are shifted ^ and $
Map clinov <recursive> µ #
Map clinov <recursive> § <Bslash>
Map clinov <recursive> ¨ {
Map clinov <recursive> £ }
Map clinv  <recursive> ² [
Map clinv  <recursive> ³ ]
Map clinov <recursive> ° <Bar>

Map nox ²² [[
Map nox ³³ ][
Map nox ³² ]]
Map nox ²³ []

" }}}

" Fixes {{{
" For when vim doesn’t Do What I Mean

" Y yanks until EOL, like D and C
" Default: Y means yy
Map n Y y$

" The cursor can always go over the EOL
" Default: only works if the line is empty
set virtualedit=onemore,block
Map n cov :set virtualedit=block,<C-R>=&ve=~'all'?'onemore':'all'<CR><CR>

" clipboard=unnamed doesn’t work in v-mode
Map x p "*p

" g< doesn’t seem to work
Map n g< :set nomore<CR>:messages<CR>:set more

" Arrow keys can cross line borders (but not h and l)
set whichwrap=[,<,>,]

" Escape sequences and insert mode timeout instantly
set notimeout ttimeout timeoutlen=1

" Redo with U
Map n U <C-R>

" Backspace can cross line borders
set backspace=indent,eol,start

" - Don’t overwrite registers with single characters
" - Don’t clutter undo history when deleting 0 characters
" - Allow Backspace and Del to wrap in normal mode
Map n x     :call DeleteOne(+v:count1, 0)<CR>
Map n X     :call DeleteOne(-v:count1, 0)<CR>
Map n <Del> :call DeleteOne(+v:count1, 1)<CR>
Map n <BS>  :call DeleteOne(-v:count1, 1)<CR>

function! s:VirtCol()
	if col('.') == 1
		return 1
	endif
	normal! h
	let res = virtcol('.') + 1
	normal! l
	return res
endfunction

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
Map n <C-W>        "_db
Map n <C-Del>      "_dw
Map i <C-Del> <C-O>"_dw
Map c <C-Del> <C-\>esubstitute(getcmdline(),'\v%'.getcmdpos().'c.{-}(><Bar>$)\s*','','')<CR>

" Don’t remove indentation when moving
set cpoptions+=I

" Start a new undoable insert for each new non-empty line and fix indent
if has('vim_starting')
	Map i <CR> <C-R>=MyCR()<CR>
endif

function! MyCR()
	if match(getline('.'), '\v^\s*$') < 0
		return neocomplete#close_popup() . "\<C-G>u\n"
	endif
	return strlen(getline('.')) ? "\<C-U>\n" : "\n"
endfunction

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

" }}}

" UNIX shortcuts {{{

" H W A E U
" Ctrl-H is always equivalent to Backspace
Map clinov <recursive> <C-H> <Backspace>
Map clinov <recursive> <C-B> <Left>
Map clinov <recursive> <C-F> <Right>
Map clinov <recursive> <C-Backspace> <C-W>
Map clinov <recursive> <C-A> <Home>
Map clinov <recursive> <C-E> <End>

Map i <Home> <C-O>^

" Ctrl-U: delete to beginning
" Already defined in insert and command modes
nnoremap <C-U> d^
onoremap <C-U>  ^
inoremap <C-U> <C-G>u<C-U>

" Ctrl-A / Ctrl-E always move to start / end of line, like shells and emacs
" Default: can only be done in command mode with Ctrl-B / Ctrl-E
" Overrides: i_CTRL-A (redo last insert) -- use Ctrl-G instead
" Overrides: c_CTRL-A (list all matches) -- no replacement
" Overrides:   CTRL-A (increment number) -- use Ctrl-S instead
" Overrides: i_CTRL-E (copy from below)  -- use Ctrl-Q instead
" Overrides:   CTRL-E (scroll one down)  -- see scrolling

" Ctrl-Q / Ctrl-Y always copy the character above / below the cursor
" Default: can only be done in insert mode with Ctrl-E / Ctrl-Y
" Overrides: i_CTRL-Q (insert verbatim)  -- use Ctrl-V
" Overrides:   CTRL-Y (scroll one up)    -- see scrolling
nnoremap <C-Q> i<C-E><Esc>l
nnoremap <C-Y> i<C-Y><Esc>l
inoremap <expr> <C-Q> neocomplete#close_popup() . "\<C-E>"
inoremap <expr> <C-Y> neocomplete#close_popup() . "\<C-Y>"

" Ctrl-T / Ctrl-D always add / remove indent
" Default: only works in insert mode; << and >> behave differently
" Overrides: CTRL-T (pop tag) CTRL-D (scroll half-page down)
nnoremap <C-T>   :call Indent(0)<CR>
nnoremap <C-D>   :call Indent(1)<CR>

function! Indent(backward)
	let save = virtcol('.') - indent('.')
	if a:backward
		<
	else
		>
	endif
	execute 'normal! ' . (save + indent('.')) . '|'
endfunction

" Increment / decrement
inoremap <C-S> <C-O><C-A>
inoremap <nowait> <C-X> <C-O><C-X>
nnoremap <C-S> <C-A>

" }}}

" Mappings galore {{{

let mapleader = '_'

" Common commands: !
nnoremap <silent> !: q:
nnoremap <silent> !q :<C-U>q<CR>
nnoremap <silent> !Q :<C-U>q!<CR>
nnoremap <silent> !w :<C-U>w<CR>
nnoremap <silent> !W :<C-U>silent w !sudo tee % >/dev/null<CR>
nnoremap <silent> !m :<C-U>make<CR>
nnoremap          !t :<C-U>tab drop<Space>
nnoremap          !T :<C-U>tabedit<Space>
nnoremap          !h :<C-U>vert help<Space>
nnoremap <silent> !H :<C-U>Unite help<CR>

" c selects current line, without the line break at the end
" TODO: use text-obj-user instead
onoremap <silent> c :<C-U>normal! 0v$<CR>

" s to search and replace with Perl
Map nx s /
nnoremap S :%s\g<Left><Left>
xnoremap S :perldo s''g<Left><Left>

noremap <expr> ,z winline() <= &scrolloff + 1 ? 'zz' : 'zt'
nmap gs <Plug>(openbrowser-smart-search)
vmap gs <Plug>(openbrowser-smart-search)

" Skype stupidity
nnoremap <Leader>ç :call SendLine()<CR>

function! SendLine()
	execute "silent! !xdotool key super+s type --delay 0 '"
				\ . getline('.') . "'\n"
	execute "silent! !xdotool key Return super+g"
	normal! dd
endfunction

nnoremap <Leader>? $?\?\zs<CR>d/\ze :<CR>lgpd/\v\ze[);]<Bar>$<CR>?\?<CR>p
nnoremap <expr> <Leader>w "\<C-W>" . GetChar()

" Unimpaired-style mappings
nnoremap <expr> [j repeat("\<C-O>", v:count1)
nnoremap <expr> ]j repeat("\<C-I>", v:count1)
nnoremap <expr> [c QFSJump('', -1)
nnoremap <expr> ]c QFSJump('', +1)

nnoremap _u :UndotreeToggle<CR>

nnoremap <Leader>= :Tabularize /
nnoremap <Leader>: :\zs/l0r1<Home>Tabularize /

" Map Q to something useful
Map nx Q gw
Map o  Q ap

" Executes current line
nnoremap <silent> <Leader>e :execute getline('.')<CR>
xnoremap <silent> <Leader>e :call Execute(join(getline("'<", "'>"), "\n"))<CR>

function! Execute(command) range
	for line in split(substitute(a:command, '\v\n\s*\', '', 'g'), "\n")
		execute line
	endfor
endfunction

" Insert timestamp
nnoremap !d :1,9s/Last change: \zs.*/\=strftime("%c")/<CR>

" Follow tags with Return
Map n <recursive> <CR> <C-]>

" Preserve CTRL-A
inoremap <nowait> <C-G> <C-A>

" Swap charwise and blockwise visual modes
Map nx v <C-V>
Map nx <C-V> v

" Select the last modified text
nnoremap gc  `[v`]

" Out of two similar commands, the most common should be lowercase
" Goto definition: global > local
Map n gd gD
Map n gD gd

" Append to: end of line > one character
nnoremap a A
nnoremap A a

" }}}

" Plugin config {{{

" NerdCommenter
let g:NERDSpaceDelims = 1

inoremap <C-C> <C-O>:call NERDComment('n', 'toggle')<CR>
nnoremap <C-C>      :call NERDComment('n', 'toggle')<CR>j
vnoremap <C-C>      :call NERDComment('v', 'toggle')<CR>gv

" Subliminal
nmap <C-LeftMouse> <LeftMouse><C-_>
xnoremap <silent> I       :SubliminalInsert<CR>
xnoremap <silent> A       :SubliminalAppend<CR>
xnoremap <silent> R       :SubliminalInsert<CR><Insert>
xnoremap <silent> c    xgv:SubliminalInsert<CR>
xnoremap <silent> <BS>    :SubliminalInsert<CR><BS>
xnoremap <silent> <Del>   :SubliminalAppend<CR><Del>
xnoremap <silent> <C-U>   :SubliminalInsert<CR><C-U>
xnoremap <silent> <C-W>   :SubliminalInsert<CR><C-W>
xnoremap <silent> <C-S>   :SubliminalInsert<CR><C-S>
xnoremap <silent> <C-X>   :SubliminalInsert<CR><C-X>
xnoremap <silent> <C-Del> :SubliminalAppend<CR><C-Del>
xnoremap <silent> <C-Y>   :SubliminalInsert<CR><C-Y>
xnoremap <silent> <C-Q>   :SubliminalInsert<CR><C-E>
vnoremap <silent> <C-T>   :SubliminalInsert<CR><C-T>
vnoremap <silent> <C-D>   :SubliminalInsert<CR><C-D>

" Dragonfly
xmap <Left>  <plug>(dragonfly_left)
xmap <Down>  <plug>(dragonfly_down)
xmap <Up>    <plug>(dragonfly_up)
xmap <Right> <plug>(dragonfly_right)
xmap H       <plug>(dragonfly_left)
xmap J       <plug>(dragonfly_down)
xmap K       <plug>(dragonfly_up)
xmap L       <plug>(dragonfly_right)
xmap P       <plug>(dragonfly_copy)

" Filetypes
call vimfiler#set_execute_file('_', 'grim')
call vimshell#set_execute_file('_', 'grim')
call vimshell#set_execute_file('bmp,jpg,png,gif', 'xsiv')
call vimfiler#set_execute_file('bmp,jpg,png,gif', 'gexe xsiv')

" VimShell
let g:vimshell_prompt_expr =
			\ 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
let g:vimshell_vimshrc_path = expand('~/.vim/shrc')
let g:vimshell_split_command = 'tabnew' " 'vsplit'

" VimFiler
let g:vimfiler_as_default_explorer  = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_enable_auto_cd       = 1
let g:vimfiler_ignore_pattern       = '^$'
" TODO: patch vimfiler for winwidth

Map n cd :VimFiler -buffer-name=cd -winwidth=49 -split -toggle<CR>
Map n cD :VimFilerTab -buffer-name=cD ~<CR>
Map n <Leader><CR> :execute 'VimShellPop' '-buffer-name=sh' t:cwd<CR>

" Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
let g:unite_kind_cdable_lcd_command = 'Tcd'
let g:unite_enable_start_insert = 1
let g:unite_source_history_yank_enable = 1

if executable('ag')
	" Use ag in unite grep source.
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts =
				\ '--line-numbers --nocolor --nogroup --hidden ' .
				\ '--ignore .hg --ignore .svn --ignore .git'
	let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
	" Use ack in unite grep source.
	let g:unite_source_grep_command = 'ack-grep'
	let g:unite_source_grep_default_opts = '--no-heading --no-color -a -H'
	let g:unite_source_grep_recursive_opt = ''
endif

nnoremap gf    :<C-u>Unite file_rec/async<CR>
nnoremap gr    :<C-U>Unite grep:.<CR>
nnoremap gl    :<C-U>Unite line<CR>
nnoremap gk    :<C-U>Unite directory<CR>
nnoremap gu    :<C-U>Unite undo<CR>
nnoremap gj    :<C-U>Unite jump<CR>
nnoremap gc    :<C-U>Unite change<CR><C-O>3G
nnoremap <C-R> :<C-u>Unite file_mru<CR><C-O>3G
nnoremap gp    :<C-u>Unite history/yank<CR><C-O>3G
nnoremap ,n    :<C-U>Unite neobundle/log<CR>[]

" xmledit
let g:xmledit_enable_html = 1
let g:xml_use_xhtml = 1

" Airline
set noshowmode    " Airline already displays the mode
set laststatus=2  " Always show the statusline

let g:airline#extensions#tabline#enabled    = 1
let g:airline_powerline_fonts               = 1
let g:airline#extensions#whitespace#enabled = 0

" }}}

" Managing multiple windows / tabs {{{

" Geometry
set splitright splitbelow
set noequalalways
set winwidth=88
set previewheight=8
set cmdwinheight=3
set winminwidth=6

augroup SmartTabClose
	autocmd!
	autocmd BufHidden * if winnr('$') == 1 && (&diff || !len(expand('%')))
				\ | q
				\ | endif
augroup END

" Use Tab to switch between windows
Map n <Tab>   <C-W>w
Map n <S-Tab> <C-W>W

" gy is easier to type than gT
nnoremap gy gT
" Control-Tab is nice and consistent with browsers, but only works in the
" GUI
Map n <C-Tab>   gt
Map n <C-S-Tab> gT

" }}}

" Scrolling {{{

" Keep a few lines around the cursor
set scrolljump=4
set scrolloff=20

" Horizontal scrolling
set sidescroll=2
set sidescrolloff=8

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
Map nv  <expr> <Space>           Scroll(&lines-5, 0)
Map nv  <expr> <S-Space>         Scroll(&lines-5, 1)
Map nvi <expr> <PageDown>        Scroll(&lines-5, 0)
Map nvi <expr> <PageUp>          Scroll(&lines-5, 1)
Map nv  <expr> <C-J>             Scroll(mode() ==# 'n' ? 20 : 8, 0)
Map nv  <expr> <C-K>             Scroll(mode() ==# 'n' ? 20 : 8, 1)

Map c <C-J> <Down>
Map c <C-K> <Up>
Map i <expr> <C-J> "\<Esc>j" . g:last_insert_col . "\<Bar>i"
Map i <expr> <C-K> "\<Esc>k" . g:last_insert_col . "\<Bar>i"

augroup SaveLastInsertColumn
	autocmd!
	autocmd InsertEnter * let g:last_insert_col = virtcol('.')
augroup END

" }}}

" Pasting {{{

" Emulate xterm behaviour
Map clinov <S-Insert> <MiddleMouse>

" After a paste, leave the cursor at the end and fix indent
set clipboard=unnamed
lnoremap <C-R> <C-R><C-P>

function! ConditionalPaste(invert, where)
	let type = getregtype() =~ "\<C-V>" ? 'Block' :
				\ xor(a:invert, getreg() =~ "\n") ? 'Indented' : 'Char'
	execute "normal \<Plug>UnconditionalPaste" . type . a:where
	call FixPaste() "\<CR>
endfunction

function! FixPaste()
	if g:repeat_sequence !~ 'UnconditionalPaste'
		return
	endif
	if g:repeat_sequence =~ 'Indented'
		normal! `[v`]=`]$
	elseif g:repeat_sequence =~ 'Block'
		execute 'normal! `[' . (strpart(getregtype(), 1) - 1) . 'l'
	else
		normal! `]
	endif
	let g:repeat_sequence .= ":call FixPaste()\<CR>"
	let g:repeat_tick = b:changedtick
endfunction

nnoremap <silent> p  :call ConditionalPaste(0, 'After')<CR>
nnoremap <silent> P  :call ConditionalPaste(0, 'Before')<CR>
nnoremap <silent> cp :call ConditionalPaste(1, 'After')<CR>
nnoremap <silent> cP :call ConditionalPaste(1, 'Before')<CR>
nmap <Leader>Pc <Plug>UnconditionalPasteCharBefore
nmap <Leader>pc <Plug>UnconditionalPasteCharAfter
nmap <Leader>Pl <Plug>UnconditionalPasteLineBefore
nmap <Leader>pl <Plug>UnconditionalPasteLineAfter
nmap <Leader>Pb <Plug>UnconditionalPasteBlockBefore
nmap <Leader>pb <Plug>UnconditionalPasteBlockAfter
nmap <Leader>Pi <Plug>UnconditionalPasteIndentedBefore
nmap <Leader>pi <Plug>UnconditionalPasteIndentedAfter
nmap <Leader>P, <Plug>UnconditionalPasteCommaBefore
nmap <Leader>p, <Plug>UnconditionalPasteCommaAfter
nmap <Leader>Pq <Plug>UnconditionalPasteQueriedBefore
nmap <Leader>pq <Plug>UnconditionalPasteQueriedAfter
nmap <Leader>PQ <Plug>UnconditionalPasteRecallQueriedBefore
nmap <Leader>pQ <Plug>UnconditionalPasteRecallQueriedAfter
nmap <Leader>Pu <Plug>UnconditionalPasteUnjoinBefore
nmap <Leader>pu <Plug>UnconditionalPasteUnjoinAfter
nmap <Leader>PU <Plug>UnconditionalPasteRecallUnjoinBefore
nmap <Leader>pU <Plug>UnconditionalPasteRecallUnjoinAfter
nmap <Leader>Pp <Plug>UnconditionalPastePlusBefore
nmap <Leader>pp <Plug>UnconditionalPastePlusAfter
nmap <Leader>PP <Plug>UnconditionalPasteGPlusBefore
nmap <Leader>pP <Plug>UnconditionalPasteGPlusAfter

Map n "" :let g:repeat_reg[1] = '"'<CR>""

" Block-mode paste pastes on each block
xnoremap p "_c<C-R>"<Esc>

" }}}

" git power {{{

" Fugitive
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gd <C-W>o:Gdiff<CR><C-W>r
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gl :Glog<CR>
nnoremap <silent> <Leader>gr :Gread<CR>
nnoremap <silent> <Leader>gw :Gwrite<CR>
nnoremap <silent> <Leader>ge :Gedit<CR>
nnoremap          <Leader>gg :Git!<Space>

" Diffs
set diffopt=filler,context:5,foldcolumn:1

" TODO: Manage hunks, jump more than once, ...
function! QFSJump(filter, direction)
	let delta = v:count1 * a:direction
	let lnum = []
	let pos = (a:direction == -1 ? 0 : -1)
	for sign in QuickfixsignsListBufferSigns(bufnr(''))
		call add(lnum, sign['lnum'])
		if sign['lnum'] < line('.') + max([a:direction, 0])
			let pos += 1
		endif
	endfor
	return lnum[(pos + delta) % len(lnum)] . 'G'
endfunction

"g:quickfixsigns_icons Disable signs on those special buffers
" TODO: patch qfs to operate on a per-buffer basis
let g:quickfixsigns_blacklist_buffer =
			\ '\v(vimfiler|vimshell|unite|Command Line|\.txt|^$)'
let g:quickfixsigns_icons = {}
Map n <Leader>q :QuickfixsignsToggle<CR>

" }}}

" File management {{{

set updatetime=1000 " This is used by a lot of plugins

" Make sure all buffers in a tab share the same cwd
augroup TabDir
	autocmd!
	autocmd BufReadPost,BufNewFile,BufEnter * call SetTcd()
augroup END

command! -nargs=1 Tcd lcd <args> | call Tcd()

function! SetTcd()
	if !exists('t:cwd') || !isdirectory(t:cwd)
		if strlen(&l:bufhidden) || !strlen(expand('%'))
			return
		endif
		let t:cwd = expand('%:p:h')
	endif
	execute 'lcd' t:cwd
endfunction

function! Tcd()
	let t:cwd = getcwd()
	if !exists('s:recursing')
		let s:recursing = 1
		" normal cdcd
		" Breaks cd in vimfiler
		unlet s:recursing
	endif
endfunction

function! WipeHiddenBuffers()
	for i in range(1, bufnr('$'))
		if bufexists(i) && type(tlib#tab#TabWinNr(i)) == 0
			execute 'bwipeout' i
		endif
	endfor
endfunction
command! WipeHiddenBuffers call WipeHiddenBuffers()

" }}}

" Experimental {{{
nnoremap <S-LeftMouse>  <LeftMouse>
nnoremap <LeftDrag>     <C-V><LeftDrag>
vnoremap <LeftDrag>     <C-V><C-V>gv<LeftDrag>
nnoremap <S-LeftMouse>  <LeftMouse>
nnoremap <S-LeftDrag>   V<LeftDrag>
vnoremap <S-LeftDrag>   VVgv<LeftDrag>
nnoremap <C-LeftMouse>  <LeftMouse>
nnoremap <C-LeftDrag>   V<LeftDrag>
vnoremap <C-LeftDrag>   vvgv<LeftDrag>

" Dirty dirty hacks
if has('vim_starting')
	silent! runtime autoload/tabline.vim
endif
runtime autoload/subliminal.vim
" }}}

