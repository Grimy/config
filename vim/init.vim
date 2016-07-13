scriptencoding utf-8

command! -nargs=1 Man exe 'b' . bufnr("man <args>", 1) | setf manpage | %!man <args> | col -bx

augroup Vimrc
autocmd!

set all&
set runtimepath=$VIM packpath=
set ttyfast t_RV=! t_RB=! t_SI=[6\ q t_SR=[4\ q t_EI=[2\ q
set updatetime=1000 timeoutlen=1 grepprg=ag clipboard=unnamed
set diffopt=filler,context:5,foldcolumn:0
set virtualedit=onemore,block nostartofline
set nowrap whichwrap=[,<,>,] backspace=2 matchpairs+=<:> commentstring=#\ %s
set scrolljump=1 scrolloff=20 sidescroll=2
set hlsearch incsearch ignorecase smartcase gdefault
set autoindent copyindent smarttab shiftround tabstop=4 shiftwidth=0
set fileencodings=ucs-bom,utf-8,latin1
set wildmenu wildmode=longest,full showfulltag suffixes+=.class
set complete=.,t,i completeopt=menuone pumheight=8
set conceallevel=2 concealcursor=nc
set display=lastline fillchars=stl:\ ,vert:\ ,stlnc: ,diff:X
set cursorline list listchars=tab:»\ ,eol:\ ,nbsp:·,precedes:«,extends:»
set nojoinspaces linebreak showbreak=…\ 
set shortmess=aoOstTc showtabline=0 laststatus=0 numberwidth=1
set showcmd ruler rulerformat=%24(%=%1*%f%3(%m%)%-6.6(%l,%v%)%)
set splitright splitbelow noequalalways winwidth=90
set hidden backup autoread noswapfile undofile history=50
set spelllang=en,fr langnoremap langmap=à@,è`,é~,ç_,’`,ù%
set foldmethod=marker foldlevelstart=0 foldcolumn=0
set foldtext=printf('%-69.68S(%d\ lines)',getline(v:foldstart)[5:],v:foldend-v:foldstart)

" XDG
let &backupdir = $XDG_DATA_HOME . '/vim/backup'
let &undodir   = $XDG_DATA_HOME . '/vim/undo'
let &viminfo  .= ',n' . $XDG_DATA_HOME . '/vim/viminfo'

" Edit directories
autocmd BufEnter * if isdirectory(expand('<afile>')) | exec '!vidir .' | q | endif

" Do not highlight spaces when typing
autocmd InsertEnter * set listchars-=trail:.
autocmd InsertLeave * set listchars+=trail:.

" Automatically check if the file changed on disk
autocmd BufEnter,FocusGained,CursorMoved * checktime

" Check for .c
autocmd BufRead * if filereadable(expand('%').'.c') | exec 'e' expand('%').'.c' | endif

" Jump to the last position when reopening file
autocmd BufReadPost * silent! normal! g`"zz

" Fold open/close
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zv0' : 'l'

" Y yanks until EOL, like D and C
nnoremap <silent> Y y$
noremap $ $l

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
noremap! <C-H> <C-W>
nnoremap <C-H> "_db
nnoremap <silent> [3;5~ "_dw
inoremap <silent> [3;5~ <C-O>"_dw
cnoremap [3;5~ <C-\>esubstitute(getcmdline(),'\v%'.getcmdpos().'c.{-}(><Bar>$)\s*','','')<CR>

" Auto-escape '/' in search
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" Don’t move the cursor when yanking in v-mode
xnoremap y ygv<Esc>

" Autoquit when the last buffer is useless
autocmd BufHidden * if winnr('$') == 1 && (&diff || !len(expand('%'))) | q | endif

" UNIX shortcuts
nnoremap <C-U> d^
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

" Ctrl-L: clear highlighting
nnoremap <silent> <C-L> :<C-U>noh<CR>
inoremap <C-L> <C-O>:<C-U>noh<CR>
autocmd CursorHold,TextChanged * call feedkeys("\<C-L>")

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
nnoremap <C-F> :e %:h<CR>i

" Esc: fix everything
nnoremap <silent> <Esc> :<C-U>diffu<Bar>lcl<Bar>pc<Bar>ccl<Bar>redr!<CR>

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

" Remap otherwise useless keys (TODO H, M, - and +)
noremap Q gw
nnoremap <silent> ; .wn

" Custom operators
onoremap <silent> c :<C-U>normal! ^v$h<CR>
onoremap <C-U> ^
onoremap Q ap
onoremap r :<C-U>normal! `[v`]<CR>
onoremap p ap

cscope add cscope.out

" Common commands with “!”
let g:bangmap = {
	\ 'b': 'b ', 'v': 'vs ', 't': 'tab drop ',
	\ 'd': "cscope find g \<C-R>\<C-W>\n",
	\ 'c': "cd %:h\n", 'e': 'e ', 'E': 'e! ',
	\ 'h': 'vert help ',
	\ 'i': 'set inv',
	\ 's': "source % | setlocal filetype=vim fileencoding=utf-8\nzx",
	\ 'S': 'silent! source ' . $VIM . "/session\n",
	\ 'w': "w\n", 'W': "silent w !sudo tee % >/dev/null\n",
	\ 'q': "q\n", 'Q': "q!\n",
	\ 'l': "silent! grep ''\<Left>", 'm': "make\n",
	\ 'g': 'silent! grep /\v([<=>])\1{6}/ %' . "\n",
	\ ' ': "normal! Vip\n:!column -t\n",
	\ '=': "normal! Vip\n:!column -s= -to=\n",
	\ }
nnoremap <expr> ! ":\<C-U>" . get(g:bangmap, nr2char(getchar()), "\e")
autocmd VimLeave * exe 'mksession!' $VIM.'/session'

" Huffman-coding
nnoremap <Space> :<C-U>if &modified<Bar>w<Bar>else<Bar>echo 'No changes made'<Bar>endif<CR>
noremap <silent> v <C-V>
noremap <silent> <C-V> v
nnoremap <silent> a A

" Syntax file debugging
nnoremap ² :echo "hi<" . synIDattr(synID(line("."), col("."), 1), "name") . '> trans<'
	\ . synIDattr(synID(line("."), col("."), 0), "name") . "> lo<"
	\ . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"<CR>
