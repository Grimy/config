" Copyright © 2014, 2015 Victor Adam (Grimy) <victor@drawall.cc> {{{1
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

augroup VimRC
autocmd!

let $VIM = $HOME . '/.nvim'
let $CACHE = $VIM . '/shada'

let g:python_host_skip_check=1
let g:loaded_python3_provider=1

command! -nargs=1 Man exe 'b' . bufnr("man <args>", 1) | setf man | %!man <args> | col -bx

function! FoldText() abort
	let nbLines = v:foldend - v:foldstart
	let line = getline(v:foldstart)
	let line = substitute(line, '^\v\W+|\{+\d*$', '', 'g')
	let space = 64 - strwidth(line . nbLines)
	let line = space < 0 ? line[0:space-3] . '… ' : line . repeat(' ', space)
	return line . printf('(%d lines)', nbLines)
endfunction

" Options {{{1

set all& nomodified
set shell=/bin/sh
set helpfile=$VIM/nvimrc runtimepath=$VIM,$VIM/bundle/*
set backupdir=$VIM/shada/backups directory=$VIM/shada/swaps undodir=$VIM/shada/undos
set timeoutlen=1 grepprg=ag clipboard=unnamed
set diffopt=filler,context:5,foldcolumn:0
set virtualedit=onemore,block | noremap $ $l
set nostartofline | noremap G G$l
set whichwrap=[,<,>,] matchpairs+=<:>
set scrolljump=4 scrolloff=20 sidescroll=2
set ignorecase smartcase gdefault
set shiftround copyindent tabstop=4 shiftwidth=0
set fileencodings=ucs-bom,utf-8,latin1
set wildmode=longest,full showfulltag
set complete=.,t,i completeopt=noselect,menuone pumheight=8
set keymodel=startsel mouse=nvr
set conceallevel=2 concealcursor=nc
set synmaxcol=101
set commentstring=#\ %s
set fillchars=stl:\ ,vert:\ ,stlnc: ,diff:X
set cursorline list listchars=tab:»\ ,nbsp:·,precedes:«,extends:»
set nojoinspaces linebreak showbreak=…\ 
set shortmess=aoOstTc showtabline=0 laststatus=0 numberwidth=1
set showcmd ruler rulerformat=%42(%=%1*%m%f\ %-(#%-2B%5l,%-4v%P%)%)
set splitright splitbelow noequalalways winwidth=88 winminwidth=6 previewheight=16
set hidden backup noswapfile undofile autowrite history=50 shada=!,%,'42,h,s10
set foldmethod=marker foldminlines=3 foldnestmax=3 foldlevelstart=0 foldcolumn=0
set foldopen=insert,jump,block,hor,mark,percent,quickfix,search,tag,undo
set foldclose= foldtext=FoldText()
set spelllang=en,fr langmap=à@,è`,é~,ç_,’`,ù%

" DWIM harder {{{1

" Fold open/close
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zv0' : 'l'

" Do not highlight spaces when typing
autocmd InsertEnter * set listchars-=trail:.
autocmd InsertLeave * set listchars+=trail:.

" Automatically check if the file changed on disk
autocmd BufEnter,FocusGained,CursorMoved * checktime

" Jump  to  the  last  position  when reopening file
autocmd BufReadPost * silent! normal! g`"zz

" Y yanks until EOL, like D and C
nnoremap <silent> Y y$

" Redo with U
nnoremap <silent> U <C-R>

" Auto-reindent when pasting
nnoremap p pv`]=`]
nnoremap P Pv`]=`]

" Don’t overwrite registers with single characters
noremap <silent> x "_d<Right>
noremap <silent> X "_d<Left>
noremap <silent> <BS> "_d<Left>

" Control + BS/Del deletes entire words
nnoremap <silent> <nowait> <C-W> "_db
nnoremap <silent> <C-Del> "_dw
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

" Autoquit when the last buffer is useless
autocmd BufHidden * if winnr('$') == 1 && (&diff || !len(expand('%'))) | q | endif

" Make t_<Esc> consistent with other modes
tnoremap <Esc> <C-\><C-N>`.
tnoremap <C-^> <C-\><C-N><C-^>

" Ctrl-mappings {{{1

" UNIX shortcuts
nnoremap <C-U> d^
nnoremap <M-BS> <C-W>
noremap! <M-BS> <C-W>
noremap! <C-B> <Left>
noremap! <C-F> <Right>
noremap! <C-P> <Up>
noremap! <C-N> <Down>
noremap! <C-A> <Home>
noremap! <C-E> <End>

" Ctrl-Q / Ctrl-Y: copy the character above / below the cursor
nnoremap <C-Q> i<C-E><Esc>l
nnoremap <C-Y> i<C-Y><Esc>l
inoremap <C-Q> <C-E>

" Ctrl-T / Ctrl-D: add / remove indent
nnoremap <silent> <C-T> a<C-T><Esc>
nnoremap <silent> <C-D> a<C-D><Esc>
xmap <C-T> VVgv>gv
xmap <C-D> VVgv<gv

" Ctrl-G: do last insertion aGain
inoremap <nowait> <C-G> <C-A>
nnoremap <C-G> ".P
cnoremap <silent> <C-G> <C-R>.

" Scrolling
autocmd InsertEnter * let g:last_insert_col = virtcol('.')
inoremap <silent> <expr> <C-J> "\<Esc>j" . g:last_insert_col . "\<Bar>i"
inoremap <silent> <expr> <C-K> "\<Esc>k" . g:last_insert_col . "\<Bar>i"
noremap <silent> <C-J> 12<C-D>
noremap <silent> <C-K> 12<C-U>
cnoremap <silent> <C-J> <Down>
cnoremap <silent> <C-K> <Up>

" Various
nnoremap <C-N> <C-I>
nnoremap <C-P> :<C-P>

" Mappings galore {{{1

" Esc: fix everything
nnoremap <silent> <Esc> :<C-U>lcl<Bar>pc<Bar>ccl<Bar>set ch=2 ch=1<Bar>UndotreeHide<CR>

" Return: goto next error/search result
nnoremap <CR> :<C-U>try<Bar>lnext<Bar>catch<Bar>silent! lfirst<Bar>endtry<CR>zx

" Super Tab!
inoremap <expr> <Tab>   virtcol('.') > indent('.') + 1 ? "\<C-N>" : "\<C-T>"
inoremap <expr> <S-Tab> virtcol('.') > indent('.') + 1 ? "\<C-P>" : "\<C-D>"
nnoremap <Tab>   <C-W>w
nnoremap <S-Tab> <C-W>W

" Use L as an alternative to the remapped <C-W>
nnoremap <expr> L "\<C-W>" . nr2char(getchar())

" Find and replace
noremap s :s~~<Left>
nnoremap S :<C-U>%s~~

" Custom operators
onoremap <silent> c :<C-U>normal! ^v$h<CR>
onoremap <C-U> ^
onoremap Q ap

" Common commands with “!”
let g:bangmap = {
	\ 'b': "b ", 'v': "vs ", 't': "tab drop ",
	\ 'c': "cd %:h\n",
	\ 'T': "tab drop term://fish\r",
	\ 'e': "e ", 'E': "e! ",
	\ 'h': "vert help ",
	\ 'i': "set inv",
	\ 's': "source % | setlocal filetype=vim fileencoding=utf-8 nohlsearch\n",
	\ 'S': 'silent! source ' . $VIM . "/shada/session\n",
	\ 'w': "w\n", 'W': "silent w !sudo tee % >/dev/null\n",
	\ 'q': "q\n", 'Q': "q!\n",
	\ 'l': "silent grep ''\<Left>", 'm': "make\n",
	\ }
nnoremap <expr> ! ":\<C-U>" . get(g:bangmap, nr2char(getchar()), "\e")
autocmd VimLeave * execute 'mksession!' $VIM.'/shada/session'

" Huffman-coding
noremap <silent> v <C-V>
noremap <silent> <C-V> v
nnoremap <silent> a A

" Syntax file debugging
nnoremap ² :echo "hi<" . synIDattr(synID(line("."), col("."), 1), "name") . '> trans<'
	\ . synIDattr(synID(line("."), col("."), 0), "name") . "> lo<"
	\ . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"<CR>

" Remap otherwise useless keys (TODO H, M, - and +)
noremap Q gw
nnoremap <silent> ; .wn

" Plugin config {{{1

" NeoMake
let g:neomake_error_sign = {'text': '!!', 'texthl': 'Error'}
let g:neomake_warning_sign = {'text': '??', 'texthl': 'TODO'}
autocmd BufWritePost * Neomake

" EasyAlign, Undotree
let g:spacemap = {
	\ '=': "\<Plug>(EasyAlign)ap",
	\ 'g': ':silent! lvimgrep /\v([<=>])\1{6}/ %' . "\r",
	\ 'u': ":UndotreeHide\rLo:UndotreeShow|UndotreeFocus\r",
	\ }
nmap <expr> <Space> get(g:spacemap, nr2char(getchar()), "\e")

" FZF
nnoremap <C-F> :FZF<CR>
autocmd TermOpen */fzf* tnoremap <buffer> <Esc> <C-U><C-D>

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
xnoremap <C-A>   :SubliminalInsert<CR><C-A>
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

onoremap r :<C-U>normal! `[v`]<>
onoremap p ap
onoremap s ib
onoremap < i<
onoremap > i>
onoremap ( i(
onoremap ) i)
onoremap <nowait> [ i[
onoremap <nowait> ] i]
onoremap { i{
onoremap } i}

nnoremap <C-Up> {
nnoremap <C-Down> }

function! s:autocompl() abort
	if getline('.')[col('.') - 2] =~# '\k'
		call feedkeys("\<C-N>", 'n')
	endif
endfunction
" autocmd TextChangedI * call s:autocompl()
