scriptencoding utf-8

command! -nargs=1 Man exe 'b' . bufnr("man <args>", 1) | setf manpage | %!man <args> | col -bx
silent! cscope add cscope.out

set all&
set runtimepath=$VIM packpath= cdpath=.;$HOME path=.,,**
set backup backupdir=$XDG_DATA_HOME/vim/backup
set undofile undodir=$XDG_DATA_HOME/vim/undo
set autoread noswapfile viminfo+=n$XDG_DATA_HOME/vim/viminfo
set ttyfast t_RV=! t_RB=! t_SI=[6\ q t_SR=[4\ q t_EI=[2\ q
set grepprg=ag clipboard=unnamed diffopt=filler,context:5,foldcolumn:0
set updatetime=777 timeoutlen=1
set whichwrap=[,] matchpairs+=<:> backspace=2 nojoinspaces commentstring=#\ %s
set hlsearch incsearch ignorecase smartcase gdefault
set autoindent copyindent smarttab shiftround tabstop=4 shiftwidth=0
set wildmenu wildmode=longest,full showfulltag suffixes+=.class
set complete=.,t,i completeopt=menuone pumheight=8
set nowrap cursorline conceallevel=2 concealcursor=nc
set list listchars=tab:»\ ,nbsp:·,extends:… fillchars=vert:\ ,diff:X
set shortmess=aoOstTc showtabline=0 laststatus=0 numberwidth=1
set showcmd ruler rulerformat=%11(%1*%m%=%4.4(%l%),%-3.3(%v%)%)
set virtualedit=onemore,block nostartofline scrolloff=16
set splitright splitbelow noequalalways winwidth=90
set spelllang=en,fr langnoremap langmap=à@,è`,é~,’`,ù%
set foldmethod=marker foldlevelstart=0 foldcolumn=0
set foldtext=printf('%-69.68S(%d\ lines)',getline(v:foldstart)[5:],v:foldend-v:foldstart)

augroup Vimrc
	autocmd!
	autocmd BufRead * if filereadable(expand('%').'.c') | exec 'e' expand('%').'.c' | endif
	autocmd BufReadPost * silent! normal! g`"zz
	autocmd BufEnter * if isdirectory(expand('<afile>')) | exec '!vidir .' | q | endif
	autocmd BufEnter * silent! lcd .git/..
	autocmd BufEnter,FocusGained,CursorMoved * checktime
	autocmd CursorHold * call feedkeys("\<C-L>", 'i')
	autocmd InsertEnter * let g:last_insert_col = virtcol('.')
	autocmd BufHidden * if winnr('$') == 1 && (&diff || !len(expand('%'))) | q | endif
	autocmd VimLeave * exe 'mksession!' $VIM.'/session'
augroup END

" Consistency
nnoremap Y y$
nnoremap $ $l
nnoremap U <C-R>
nnoremap p pv`]=`]
nnoremap P Pv`]=`]
vnoremap p "_dP
nnoremap x "_d<Right>
nnoremap X "_d<Left>
nnoremap <BS> "_d<Left>
xnoremap y ygv<Esc>
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
noremap v <C-V>
noremap <C-V> v
nnoremap a A

" Esc/Tab/Space
inoremap <expr> <Tab>   virtcol('.') > indent('.') + 1 ? "\<C-N>" : "\<C-T>"
inoremap <expr> <S-Tab> virtcol('.') > indent('.') + 1 ? "\<C-P>" : "\<C-D>"
nnoremap <Tab>   <C-W>w
nnoremap <S-Tab> <C-W>W
nnoremap <Esc>   :<C-U>diffu<Bar>lcl<Bar>pc<Bar>ccl<Bar>redr!<CR>
nnoremap <Space> :<C-U>if &modified<Bar>w<Bar>else<Bar>echo 'No changes made'<Bar>endif<CR>

" Ctrl+BS/Del
nnoremap <C-W> "_db
nnoremap [3;5~ "_dw
inoremap [3;5~ <C-O>"_dw
cnoremap [3;5~ <C-\>esubstitute(getcmdline(),'\v%'.getcmdpos().'c.{-}(><Bar>$)\s*','','')<CR>

" Unix mappings
noremap! <C-A> <Home>
noremap! <C-B> <Left>
noremap! <C-E> <End>
noremap! <C-F> <Right>
noremap! <C-N> <Down>
noremap! <C-P> <Up>
nnoremap <C-U> d^
nnoremap <nowait> <C-W> "_db

" Indent
nnoremap <silent> <C-T> a<C-T><Esc>
nnoremap <silent> <C-D> a<C-D><Esc>
xmap <C-T> VVgv>gv
xmap <C-D> VVgv<gv

" Scrolling
inoremap <silent> <expr> <C-J> "\<Esc>j" . g:last_insert_col . "\<Bar>i"
inoremap <silent> <expr> <C-K> "\<Esc>k" . g:last_insert_col . "\<Bar>i"
noremap  <silent> <C-J> 12<C-D>
noremap  <silent> <C-K> 12<C-U>
cnoremap <C-J> <Down>
cnoremap <C-K> <Up>

" Find and replace
command! -range=% -nargs=1 S <line1>,<line2>s<args>
noremap S :S//
nnoremap <silent> ; .wn

" Folds
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zv0' : 'l'

" Custom operators
onoremap Q ap
onoremap r :<C-U>normal! `[v`]<CR>
onoremap p ap

" Various
nnoremap <silent> <C-L> :<C-U>noh<CR>
inoremap <nowait> <C-G> <C-A>
nnoremap <C-G> ".P
nnoremap <C-N> <C-I>
nnoremap <C-P> :<C-P>
inoremap <C-Q> <C-E>
nnoremap <C-Q> i<C-E><Esc>l
nnoremap <C-Y> i<C-Y><Esc>l
nnoremap <expr> L "\<C-W>" . nr2char(getchar())
noremap Q gw
nnoremap ² :echo "hi<" . synIDattr(synID(line("."), col("."), 1), "name") . '> trans<'
	\ . synIDattr(synID(line("."), col("."), 0), "name") . "> lo<"
	\ . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"<CR>

" Free keys: <C-E>, <C-R>, <C-F>, <C-B>, H, L, M, -, +, &

" Bang!
let g:bangmap = {
	\ 'b': 'b ',
	\ 'v': 'vert sfind ', 'V': 'vs ',
	\ 'd': "cscope find g \<C-R>\<C-W>\n",
	\ 'e': 'find ', 'E': "e!\n",
	\ 'h': 'vert help ',
	\ 'i': 'set inv',
	\ 'l': "silent! grep ''\<Left>", 'm': "make\n",
	\ 'q': "q\n", 'Q': "q!\n",
	\ 's': "source % | setlocal filetype=vim fileencoding=utf-8\nzx",
	\ 'S': 'silent! source ' . $VIM . "/session\n",
	\ 't': 'tabfind ',
	\ 'w': "w\n", 'W': "silent w !sudo tee % >/dev/null\n",
	\ ' ': "normal! Vip\n:!column -t\n",
	\ '=': "normal! Vip\n:!column -s= -to=\n",
	\ }
nnoremap <expr> ! ":\<C-U>" . get(g:bangmap, nr2char(getchar()), "\e")
