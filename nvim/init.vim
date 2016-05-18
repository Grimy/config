scriptencoding utf-8

augroup Vimrc
autocmd!

let $VIM = $XDG_CONFIG_HOME . '/nvim'
let g:python_host_skip_check=1
let g:loaded_python3_provider=1

command! -nargs=1 Man exe 'b' . bufnr("man <args>", 1) | setf manpage | %!man <args> | col -bx

set all&
set helpfile=$VIM/init.vim runtimepath=$VIM
set updatetime=1000 timeoutlen=1 grepprg=ag clipboard=unnamed
set diffopt=filler,context:5,foldcolumn:0
set virtualedit=onemore,block nostartofline
set nowrap whichwrap=[,<,>,] matchpairs+=<:> commentstring=#\ %s
set mouse= scrolljump=1 scrolloff=20 sidescroll=2
set ignorecase smartcase gdefault
set shiftround copyindent tabstop=4 shiftwidth=0
set fileencodings=ucs-bom,utf-8,latin1
set wildmode=longest,full showfulltag suffixes+=.class
set complete=.,t,i completeopt=menuone pumheight=8
set conceallevel=2 concealcursor=nc
set fillchars=stl:\ ,vert:\ ,stlnc: ,diff:X
set cursorline list listchars=tab:»\ ,eol:\ ,nbsp:·,precedes:«,extends:»
set nojoinspaces linebreak showbreak=…\ 
set shortmess=aoOstTc showtabline=0 laststatus=0 numberwidth=1
set showcmd ruler rulerformat=%24(%=%1*%f%3(%m%)%-6.6(%l,%v%)%)
set splitright splitbelow noequalalways winwidth=88 winminwidth=6 previewheight=16
set hidden backup backupdir-=. noswapfile undofile history=50 shada=!,%,'42,h,s10
set spelllang=en,fr langmap=à@,è`,é~,ç_,’`,ù%
set foldmethod=marker foldlevelstart=0 foldcolumn=0
set foldtext=printf('%-69.68S(%d\ lines)',getline(v:foldstart)[5:],v:foldend-v:foldstart)

" Do not highlight spaces when typing
autocmd InsertEnter * set listchars-=trail:.
autocmd InsertLeave * set listchars+=trail:.

" Automatically check if the file changed on disk
autocmd BufEnter,FocusGained,CursorMoved * checktime

" Jump  to  the  last  position  when reopening file
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

" Autoquit when the last buffer is useless
autocmd BufHidden * if winnr('$') == 1 && (&diff || !len(expand('%'))) | q | endif

" UNIX shortcuts
map <M-BS> <C-W>
nnoremap <C-U> d^
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

" Ctrl-L: clear highlighting
" TODO diffupdate ? redraw! ?
noremap <silent> <C-L> :<C-U>noh<CR>
vnoremap <silent> <C-L> <Nop>
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
nnoremap <silent> <Esc> :<C-U>lcl<Bar>pc<Bar>ccl<Bar>set ch=2 ch=1<CR>

" Return: goto next error/search result
nnoremap <CR> :<C-U>try<Bar>cnext<Bar>catch<Bar>cfirst<Bar>endtry<CR>zx

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

" Common commands with “!”
let g:bangmap = {
	\ 'b': 'b ', 'v': 'vs ', 't': 'tab drop ',
	\ 'c': "cd %:h\n",
	\ 'e': 'e ', 'E': 'e! ',
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
