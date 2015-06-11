" Copyright © 2014 Grimy <Victor.Adam@derpymail.org> {{{1
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

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

" Returns the first virtual column of the current character
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

augroup VimRC
autocmd!

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:sep        = s:is_windows ? '\' : '/'
let s:path       = fnamemodify(resolve(expand('<sfile>')), ':p:h') . s:sep
let s:cache      = s:path . 'cache'  . s:sep
let &runtimepath = s:path . ',' . s:path . 'bundle' . s:sep . '*'
let &helpfile    = s:path . 'nvimrc'

" Use English messages.
execute 'language' 'message' s:is_windows ? 'en' : 'C'

" Vim needs a POSIX-Compliant shell. Fish is not.
if &shell =~ 'fish'
	set shell=/bin/sh
endif

" Keycodes not automatically recognized when over ssh
Map clinov <recursive> <C-H> <C-BS>
Map clinov <recursive> <C-@> <C-Space>
Map clinov <recursive> <Esc>[3~ <Del>
Map clinov <recursive> <Esc>[3;5~ <C-Del>
Map clinov <recursive> <Esc>[1;5A <C-Up>
Map clinov <recursive> <Esc>[1;5B <C-Down>
Map clinov <recursive> <Esc>[1;5C <C-Right>
Map clinov <recursive> <Esc>[1;5D <C-Left>

execute 'cd' expand('%:p:h')

" Basic options {{{1

set incsearch gdefault nojoinspaces grepprg=ag

" Keep a few lines/columns around the cursor
set scrolljump=4 scrolloff=20 sidescroll=2 sidescrolloff=8

" Keep cursor column when scrolling
set nostartofline
Map nov G G$l

" Patterns are case sensitive iff they contain at least one uppercase
set ignorecase smartcase

" Classic four-spaces wide tab indent
set shiftround copyindent tabstop=4 shiftwidth=0

" Encoding
set fileencodings=utf-8,cp1252

" Keep lots of history in the "cache" dir
set hidden backup noswapfile undofile autowrite
autocmd VimLeave * execute 'mksession!' g:session
let &viminfo = '!,%,''42,h,s10,n' . s:cache . 'info'
let &backupdir                    = s:cache . 'backups'
let &directory                    = s:cache . 'swaps'
let &undodir                      = s:cache . 'undos'
let g:session                     = s:cache . 'session'

" Jump  to  the  last  position  when reopening file
autocmd BufReadPost * silent! normal! g`"zz

" Auto-update the file when it changed on the filesystem
set autoread
autocmd BufEnter,FocusGained * checktime

" Completion
set wildmode=longest,full showfulltag
set complete=.,t,i completeopt=menu

" GUI options {{{1

colorscheme rainbow

" Windows emulation
set keymodel=startsel,stopsel
set selectmode=key,mouse

" Vim feels much more snappy and responsive this way
set nolazyredraw
set cursorline
set synmaxcol=101
set mouse=nvr

" Show matching brackets
set matchpairs+=<:>

" Better replacement characters
set fillchars=stl:\ ,vert:\ ,stlnc: ,diff:X
set list listchars=tab:»\ ,nbsp:.,precedes:«,extends:»
let &showbreak = '… '
set display=lastline

" Disable trailing whitespace highlighting in insert mode
autocmd InsertEnter * set listchars-=trail:.
autocmd InsertLeave * set listchars+=trail:. nopaste

set conceallevel=2 concealcursor=n

" Don’t break lines in the middle of a word
set linebreak

" The undocumented c flag is vital for completion plugins
set shortmess=aoOstTc

" Folding {{{1

" Fold on braces
set foldmethod=marker foldminlines=3 foldnestmax=3 foldlevelstart=0 foldcolumn=0

" Open and close folds smartly
set foldopen=insert,jump,block,hor,mark,percent,quickfix,search,tag,undo
set foldclose=
Map n <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
Map n <expr> l foldclosed(line('.')) != -1 ? 'zv0' : 'l'

" Replacement text for the fold line
function! FoldText()
	let nbLines = v:foldend - v:foldstart
	let line = getline(v:foldstart)
	let line = substitute(line, '^\v\W+|\{+\d*$', '', 'g')
	let space = 64 - strwidth(line . nbLines)
	let line = space < 0 ? line[0:space-3] . '… ' : line . repeat(' ', space)
	return line . printf('(%d lines)', nbLines)
endfunction
set foldtext=FoldText()

" Un clavier azerty en vaut deux ! {{{1

set spelllang=en,fr
silent! set langnoremap
set langmap=à@,è`,é~,ç_,’`,ù%
lmap à @
lmap è `
lmap é ~
lmap ç _
lmap ù %
lmap ’ `

" TODO map these at the Xmodmap level
Map clinov <recursive> µ #
Map clinov <recursive> § <Bslash>
Map clinov <recursive> ° <Bar>

" DWIM harder {{{1

" Y yanks until EOL, like D and C
Map n Y y$

" The cursor can always go over the EOL
" Default: only works if the line is empty
set virtualedit=onemore,block

" Arrow keys can cross line borders (but not h and l)
set whichwrap=[,<,>,]

" Escape sequences and insert mode timeout instantly
set timeoutlen=1

" Redo with U
Map n U <C-R>

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

" Auto-escape '/' in search
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" Don’t move the cursor when yanking in v-mode
Map x y ygv<Esc>

" Replace relative to the screen (e.g. it takes 4 letters te replace a tab)
Map n R gR
inoremap <Insert> <C-O>gR

" Vertical movement relative to the screen (matters when 'wrap' is on)
nnoremap <silent> j gj
nnoremap <silent> k gk
noremap <silent> <Down> gj
noremap <silent> <Up>   gk

" Diffs
set diffopt=filler,context:5,foldcolumn:0

" Automatically open the quickfix window when there are errors
autocmd QuickFixCmdPost * redraw! | cwindow

" UNIX shortcuts {{{1

Map clinov <recursive> <C-H> <C-BS>
Map clinov <recursive> <C-?> <BS>
Map cliov  <recursive> <C-B> <Left>
Map cliov  <recursive> <C-F> <Right>
Map cliov  <recursive> <C-P> <Up>
Map cliov  <recursive> <C-N> <Down>
Map clinov <recursive> <C-BS> <C-W>

" Ctrl-U: delete to beginning
" Already defined in insert and command modes
nnoremap <C-U> d^
onoremap <C-U>  ^

" Ctrl-A / Ctrl-E always move to start / end of line, like shells and emacs
Map cliov <recursive> <C-A> <Home>
Map cliov <recursive> <C-E> <End>
Map i <Home> <C-O>^

" Ctrl-Q / Ctrl-Y always copy the character above / below the cursor
nnoremap <C-Q> i<C-E><Esc>l
nnoremap <C-Y> i<C-Y><Esc>l
inoremap <C-Q> <C-E>

" Ctrl-T / Ctrl-D always add / remove indent
Map n <C-T> :call KeepPos('>')<CR>
Map n <C-D> :call KeepPos('<')<CR>
xmap <C-T> VVgv<plug>(dragonfly_right)
xmap <C-D> VVgv<plug>(dragonfly_left)

" Mappings galore {{{1

" Esc: fix everything
Map n <Esc> :<C-U>lcl<Bar>pc<Bar>ccl<Bar>set ch=2 ch=1<Bar>UndotreeHide<CR>

" Super Tab!
inoremap <expr> <Tab>   virtcol('.') > indent('.') + 1 ? "\<C-N>" : "\<C-T>"
inoremap <expr> <S-Tab> virtcol('.') > indent('.') + 1 ? "\<C-P>" : "\<C-D>"

" Find and replace
nnoremap s :s:
xnoremap s :s:
nnoremap S :%s:\<<C-R><C-W>\>:
xnoremap S "vy:%s:\V<C-R>v:

" Pasting
Map clinov <S-Insert> <MiddleMouse>
set clipboard=unnamed
lnoremap <C-R> <C-R><C-P>

" c selects current line, without the line break at the end
onoremap <silent> c :<C-U>normal! ^v$h<CR>

" Common commands with “!”
let g:bangmap = {
	\ 'b': "b ", 'v': "vs ", 't': "tab drop ",
	\ 'T': "tab drop term://fish\<CR>",
	\ 'e': "e ", 'E': "e! ",
	\ 'f': "FZF\<CR>",
	\ 'h': "vert help ",
	\ 'i': "set inv",
	\ 's': 'silent! source ' . g:session . "\n",
	\ 'w': "w\n", 'W': "silent w !sudo tee % >/dev/null\n",
	\ 'q': "q\n", 'Q': "q!\n",
	\ 'l': "silent grep ''\<Left>", 'm': "make\n",
	\ 'd': "!gdb -q -ex 'set confirm off' -ex 'b main' -ex r $(find debug/* -not -name '*.*')\n",
	\ }
nnoremap <expr> ! ":\<C-U>" . get(g:bangmap, nr2char(getchar()), "\e")

" Unimpaired-style mappings
onoremap p :<C-U>set paste<CR>o

" Various
Map nv   <C-G> ".P
Map c    <C-G> <C-R>.
nnoremap <C-N> <C-I>
nnoremap <C-P> :<C-P>
" TODO : diff markers
" \v([<=>])\1{6}

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
onoremap r :<C-U>normal! `[v`]<>

" Always append at the end of the line
Map n a A

" Syntax file debugging
nnoremap ² :echo "hi<" . synIDattr(synID(line("."), col("."), 1), "name") . '> trans<'
	\ . synIDattr(synID(line("."), col("."), 0), "name") . "> lo<"
	\ . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"<CR>

" Scrolling
Map nv <C-J> 12<C-D>
Map nv <C-K> 12<C-U>
Map c <C-J> <Down>
Map c <C-K> <Up>

autocmd InsertEnter * let g:last_insert_col = virtcol('.')
Map i <expr> <C-J> "\<Esc>j" . g:last_insert_col . "\<Bar>i"
Map i <expr> <C-K> "\<Esc>k" . g:last_insert_col . "\<Bar>i"

" Surely there’s something to do with H, M, - and +

" Plugin config {{{1

" NeoMake
let g:neomake_error_sign = {'text': '>>', 'texthl': 'Error'}
let g:neomake_warning_sign = {'text': '>>', 'texthl': 'TODO'}
autocmd BufWritePost * Neomake

" EasyAlign, Undotree
let g:spacemap = {
	\ '=': "\<Plug>(EasyAlign)ap",
	\ 'u': ":UndotreeHide\rLo:UndotreeShow|UndotreeFocus\r",
	\ }
nmap <expr> <Space> get(g:spacemap, nr2char(getchar()), "\e")

" Eclim
let g:zmap = {
	\ 'I': "JavaImportOrganize\r",
	\ 'J': "!cd ~/src/drawall/bin && java cc.drawall.ConVector\r",
	\ 'H': "JavaCallHierarchy\r",
	\ 'R': "JavaRename ",
	\ 'P': "ProjectProblems\r",
	\ 'O': "JavaImpl\r",
	\ }
nnoremap <expr> Z ":\<C-U>" . get(g:zmap, nr2char(getchar()), "\e") 

let g:EclimPythonValidate = 1
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimJavaCallHierarchyDefaultAction = 'vert split'

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

" Managing multiple windows / tabs {{{1

" Minimize clutter
set showtabline=0 laststatus=0 showcmd
set ruler rulerformat=%42(%=%1*%m%f\ %-(#%-2B%5l,%-4v%P%)%)

" Geometry
set splitright splitbelow
set noequalalways winwidth=88 winminwidth=6
set previewheight=16

" Use Tab to switch between windows
Map n <Tab>   <C-W>w
Map n <S-Tab> <C-W>W

" Restore <C-W>
nnoremap <expr> L "\<C-W>" . nr2char(getchar())

" Experimental {{{1

set commentstring=#\ %s

nnoremap - "_ddk
onoremap s ib

" Golf
autocmd BufWritePost ~/Golf/** !cat %.in 2>/dev/null | perl5.8.8 %
autocmd BufReadPost,BufEnter ~/Golf/** setlocal bin noeol filetype=perl

nnoremap <CR> :<C-U>try<Bar>lnext<Bar>catch<Bar>silent! lfirst<Bar>endtry<CR>

nnoremap <C-Z> :tab drop term://fish<CR>
