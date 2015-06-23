" Copyright © 2014, 2015 Victor Adam (Grimy) <victor@drawall.cc> {{{1
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

" Utility functions {{{1

command! -nargs=+ Map map <args>|map! <args>

" Returns the first virtual column of the current character
function! s:VirtCol() abort
	if col('.') == 1
		return 1
	endif
	normal! h
	let res = virtcol('.') + 1
	normal! l
	return res
endfunction

function! FoldText() abort
	let nbLines = v:foldend - v:foldstart
	let line = getline(v:foldstart)
	let line = substitute(line, '^\v\W+|\{+\d*$', '', 'g')
	let space = 64 - strwidth(line . nbLines)
	let line = space < 0 ? line[0:space-3] . '… ' : line . repeat(' ', space)
	return line . printf('(%d lines)', nbLines)
endfunction

function! DeleteOne(count, wrap) abort
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

" Initialization {{{1

augroup VimRC
autocmd!
set all&

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
Map <C-H> <C-BS>
Map <C-@> <C-Space>
Map <Esc>[3~ <Del>
Map <Esc>[3;5~ <C-Del>
Map <Esc>[1;5A <C-Up>
Map <Esc>[1;5B <C-Down>
Map <Esc>[1;5C <C-Right>
Map <Esc>[1;5D <C-Left>

" Options {{{1

set grepprg=ag clipboard=unnamed
set diffopt=filler,context:5,foldcolumn:0
set nojoinspaces
set virtualedit=onemore,block
set whichwrap=[,<,>,]
set timeoutlen=1
set scrolljump=4 scrolloff=20 sidescroll=2 sidescrolloff=8
set nostartofline | noremap G G$l
set ignorecase smartcase gdefault
set shiftround copyindent tabstop=4 shiftwidth=0
set fileencodings=utf-8,cp1252
set wildmode=longest,full showfulltag
set complete=.,t,i completeopt=menu
set keymodel=startsel mouse=nvr
set conceallevel=2 concealcursor=n
set nolazyredraw
set cursorline
set synmaxcol=101
set matchpairs+=<:>
set fillchars=stl:\ ,vert:\ ,stlnc: ,diff:X
set list listchars=tab:»\ ,nbsp:.,precedes:«,extends:»
set linebreak showbreak=…\  
set shortmess=aoOstTc showtabline=0 laststatus=0 numberwidth=1
set showcmd ruler rulerformat=%42(%=%1*%m%f\ %-(#%-2B%5l,%-4v%P%)%)
set splitright splitbelow
set noequalalways winwidth=88 winminwidth=6 previewheight=16
set hidden backup noswapfile undofile autowrite
autocmd VimLeave * execute 'mksession!' g:session
let &viminfo = '!,%,''42,h,s10,n' . s:cache . 'info'
let &backupdir                    = s:cache . 'backups'
let &directory                    = s:cache . 'swaps'
let &undodir                      = s:cache . 'undos'
let g:session                     = s:cache . 'session'

" Disable trailing whitespace highlighting in insert mode
autocmd InsertEnter * set listchars-=trail:.
autocmd InsertLeave * set listchars+=trail:. nopaste
autocmd BufEnter,FocusGained * checktime

set foldmethod=marker foldminlines=3 foldnestmax=3 foldlevelstart=0 foldcolumn=0
set foldopen=insert,jump,block,hor,mark,percent,quickfix,search,tag,undo
set foldclose= foldtext=FoldText()
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zv0' : 'l'

set spelllang=en,fr
set langmap=à@,è`,é~,ç_,’`,ù%

" TODO map these at the Xmodmap level
Map µ #
Map § <Bslash>
Map ° <Bar>

" DWIM harder {{{1

" Jump  to  the  last  position  when reopening file
autocmd BufReadPost * silent! normal! g`"zz

" Y yanks until EOL, like D and C
nnoremap <silent> Y y$

" Redo with U
nnoremap <silent> U <C-R>

" - Don’t overwrite registers with single characters
" - Don’t clutter undo history when deleting 0 characters
" - Allow Backspace and Del to wrap in normal mode
nnoremap <silent> x     :<C-U>call DeleteOne(+v:count1, 0)<CR>
nnoremap <silent> X     :<C-U>call DeleteOne(-v:count1, 0)<CR>
nnoremap <silent> <Del> :<C-U>call DeleteOne(+v:count1, 1)<CR>
nnoremap <silent> <BS>  :<C-U>call DeleteOne(-v:count1, 1)<CR>

" x/X in v-mode doesn’t yank (d/D still does)
xnoremap <silent> x "_d
xnoremap <silent> X "_D

" Control + BS/Del deletes entire words
nnoremap <silent> <nowait> <C-W>        "_db
nnoremap <silent> <C-Del>      "_dw
inoremap <silent> <C-Del> <C-O>"_dw
cnoremap <C-Del> <C-\>esubstitute(getcmdline(),'\v%'.getcmdpos().'c.{-}(><Bar>$)\s*','','')<CR>

" Auto-escape '/' in search
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" Don’t move the cursor when yanking in v-mode
xnoremap y ygv<Esc>

" Replace relative to the screen (e.g. it takes 4 letters te replace a tab)
nnoremap R gR
inoremap <Insert> <C-O>gR

" Vertical movement relative to the screen (matters when 'wrap' is on)
nnoremap <silent> j gj
nnoremap <silent> k gk
noremap <silent> <Down> gj
noremap <silent> <Up>   gk

" Automatically open the quickfix window when there are errors
autocmd QuickFixCmdPost * redraw! | cwindow

" UNIX shortcuts {{{1

Map <C-H> <C-BS>
Map <C-?> <BS>
Map <C-B> <Left>
Map <C-F> <Right>
Map <C-P> <Up>
Map <C-N> <Down>
Map <C-BS> <C-W>

" Use L as an alternative to the remapped <C-W>
nnoremap <expr> L "\<C-W>" . nr2char(getchar())

" Ctrl-U: delete to beginning
" Already defined in insert and command modes
nnoremap <C-U> d^
onoremap <C-U>  ^

" Ctrl-A / Ctrl-E always move to start / end of line, like shells and emacs
Map <C-A> <Home>
Map <C-E> <End>
nunmap <C-A>

" Ctrl-Q / Ctrl-Y always copy the character above / below the cursor
nnoremap <C-Q> i<C-E><Esc>l
nnoremap <C-Y> i<C-Y><Esc>l
inoremap <C-Q> <C-E>

" Ctrl-T / Ctrl-D always add / remove indent
nnoremap <silent> <C-T> a<C-T><Esc>
nnoremap <silent> <C-D> a<C-D><Esc>
xmap <C-T> VVgv<plug>(dragonfly_right)
xmap <C-D> VVgv<plug>(dragonfly_left)

" Mappings galore {{{1

" Esc: fix everything
nnoremap <silent> <Esc> :<C-U>lcl<Bar>pc<Bar>ccl<Bar>set ch=2 ch=1<Bar>UndotreeHide<CR>

" Super Tab!
inoremap <expr> <Tab>   virtcol('.') > indent('.') + 1 ? "\<C-N>" : "\<C-T>"
inoremap <expr> <S-Tab> virtcol('.') > indent('.') + 1 ? "\<C-P>" : "\<C-D>"
nnoremap <Tab>   <C-W>w
nnoremap <S-Tab> <C-W>W

" Find and replace
noremap s :s:
nnoremap S :<C-U>%s~~
xnoremap S :s~~

" Pasting
Map <S-Insert> <MiddleMouse>
lnoremap <C-R> <C-R><C-P>

" c selects current line, without the line break at the end
onoremap <silent> c :<C-U>normal! ^v$h<CR>

" Common commands with “!”
let g:bangmap = {
\ 'b': "b ", 'v': "vs ", 't': "tab drop ",
\ 'T': "tab drop term://fish\r",
\ 'e': "e ", 'E': "e! ",
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
noremap <C-G> ".P
noremap Q gw
onoremap Q ap
nnoremap <silent> ; .wn
cnoremap <silent>    <C-G> <C-R>.
nnoremap <C-N> <C-I>
nnoremap <C-P> :<C-P>

" Preserve CTRL-A
let g:surround_no_insert_mappings = 1
inoremap <nowait> <C-G> <C-A>

" Swap charwise and blockwise visual modes
noremap <silent> v <C-V>
noremap <silent> <C-V> v

" Select the last modified text
onoremap r :<C-U>normal! `[v`]<>

" Always append at the end of the line
nnoremap <silent> a A

" Syntax file debugging
nnoremap ² :echo "hi<" . synIDattr(synID(line("."), col("."), 1), "name") . '> trans<'
\ . synIDattr(synID(line("."), col("."), 0), "name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"<CR>

" Scrolling
noremap <silent> <C-J> 12<C-D>
noremap <silent> <C-K> 12<C-U>
cnoremap <silent> <C-J> <Down>
cnoremap <silent> <C-K> <Up>

autocmd InsertEnter * let g:last_insert_col = virtcol('.')
inoremap <silent> <expr> <C-J> "\<Esc>j" . g:last_insert_col . "\<Bar>i"
inoremap <silent> <expr> <C-K> "\<Esc>k" . g:last_insert_col . "\<Bar>i"

" Surely there’s something to do with H, M, - and +

" Plugin config {{{1

" NeoMake
let g:neomake_error_sign = {'text': '!!', 'texthl': 'Error'}
let g:neomake_warning_sign = {'text': '??', 'texthl': 'TODO'}
autocmd BufWritePost * Neomake

" EasyAlign, FZF, Undotree
let g:spacemap = {
	\ '=': "\<Plug>(EasyAlign)ap",
	\ 'f': ":FZF\r",
	\ 'g': ':silent! lvimgrep /\v([<=>])\1{6}/ %' . "\r",
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

" Experimental {{{1

set commentstring=#\ %s

nnoremap - "_ddk
onoremap s ib

" Golf
autocmd BufWritePost ~/Golf/** !cat %.in 2>/dev/null | perl5.8.8 %
autocmd BufReadPost,BufEnter ~/Golf/** setlocal bin noeol filetype=perl

nnoremap <CR> :<C-U>try<Bar>lnext<Bar>catch<Bar>silent! lfirst<Bar>endtry<CR>zx

nnoremap <C-Z> :tab drop term://fish<CR>
nnoremap <C-F> :tab edit term://ranger<CR>

autocmd BufHidden * if winnr('$') == 1 && (&diff || !len(expand('%'))) | q | endif

tnoremap <Esc> <C-\><C-N>`.
nnoremap p ]p
nnoremap P ]P
