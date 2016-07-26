scriptencoding utf-8

command! -nargs=1 Man exec 'b' . bufnr(<q-args>, 1) | setf man | %!man <args> | col -bx
command! -range=% -nargs=1 S <line1>,<line2>s<args>
command! -nargs=1 -complete=file_in_path O try|find <args>|catch|e <args>|endtry
silent! cscope add cscope.out

set all&
silent! set packpath=
set runtimepath=$VIM cdpath=.;$HOME path=.,,** suffixesadd=.vim,.c
set backup backupdir=$XDG_DATA_HOME/vim/backup
set undofile undodir=$XDG_DATA_HOME/vim/undo
set autoread noswapfile viminfo+=n$XDG_DATA_HOME/vim/viminfo
set ttyfast t_RV=! t_RB=! t_SI=[6\ q t_SR=[4\ q t_EI=[2\ q
set keywordprg=:Man grepprg=git\ grep\ -n\ $* clipboard=unnamed
set diffopt=filler,context:5,foldcolumn:0
set updatetime=888 timeoutlen=1
set whichwrap=<,>,[,] matchpairs+=<:> backspace=2 nojoinspaces commentstring=#\ %s
set hlsearch incsearch ignorecase smartcase gdefault
set autoindent copyindent smarttab shiftround shiftwidth=0
set wildmenu wildmode=longest,full showfulltag completeopt=menuone pumheight=8
set nowrap cursorline conceallevel=2 concealcursor=nc
set list listchars=tab:» ,nbsp:·,extends:… fillchars=stlnc: ,vert: ,diff:X
set shortmess=aoOstTc showtabline=0 laststatus=0 numberwidth=1
set showcmd ruler rulerformat=%11(%1*%m%=%4.4(%l%),%-3.3(%v%)%)
set virtualedit=onemore,block nostartofline scrolloff=16
set splitright noequalalways winwidth=84
set spelllang=en,fr langnoremap langmap=à@,è`,é~,’`,ù%
set foldmethod=marker foldlevelstart=0
set foldtext=printf('%-69.68S(%d\ lines)',getline(v:foldstart)[5:],v:foldend-v:foldstart)

augroup Vimrc
	autocmd!
	autocmd BufReadPost         * silent! normal! g`"zz
	autocmd BufEnter            * if isdirectory(expand('<afile>')) | exec '!vidir .' | q | endif
	autocmd BufEnter            * silent! lcd .git/..
	autocmd BufEnter,CursorHold * checktime
	autocmd CursorHold          * call feedkeys("\<C-L>", 'i')
	autocmd BufHidden           * if winnr('$') == 1 && (&diff || !len(expand('%'))) | q | endif
	autocmd FileChangedRO       * set noreadonly
augroup END

" Small fixes to built-ins
nnoremap Y y$
nnoremap $ $l
nnoremap p p=`]`]
nnoremap P P=`]`]
xnoremap p "_dP
nnoremap x "_d<Right>
nnoremap X "_d<Left>
nnoremap <BS> "_d<Left>
xnoremap y ygv<Esc>
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zv0' : 'l'
nnoremap <silent> <C-L> :<C-U>noh<CR>

" Consistency across modes
nnoremap <C-T> a<C-T><Esc>
nnoremap <C-D> a<C-D><Esc>
nnoremap <C-P> :<C-P>
nnoremap <C-E> i<C-E><Esc>l
nnoremap <C-Y> i<C-Y><Esc>l
nnoremap <nowait> <C-W> "_db
nnoremap <C-U> d^

" Handle ctrl+del
nnoremap [3;5~ "_dw
inoremap [3;5~ <C-O>"_dw
cnoremap [3;5~ <C-\>esubstitute(getcmdline(),'\v%'.getcmdpos().'c.{-}(><Bar>$)\s*','','')<CR>

" Shortcuts
" n-free keys: <C-R>, <C-F>, <C-B>, H, M, -, +, &
" i-free keys: <C-L>, <C-X>, <C-G>
inoremap <expr> <Tab>   virtcol('.') > indent('.') + 2 ? "\<C-N>" : "\<C-T>"
inoremap <expr> <S-Tab> virtcol('.') > indent('.') + 1 ? "\<C-P>" : "\<C-D>"
nnoremap <Tab>   <C-W>w
nnoremap <S-Tab> <C-W>W
nnoremap <Esc>   :<C-U>diffu<Bar>lcl<Bar>pc<Bar>ccl<Bar>redr!<CR>
nnoremap <Space> :<C-U>w<CR>
noremap v <C-V>
nnoremap a A
nnoremap U <C-R>
inoremap <C-J> <C-G>j
inoremap <C-K> <C-G>k
noremap <C-J> 12<C-D>
noremap <C-K> 12<C-U>
noremap S :S//
noremap Q gw
onoremap Q ap
nnoremap <C-@> cgn
nnoremap ² :echo 'syn ' . synIDattr(synID(line('.'), col('.'), 0), 'name')<CR>
onoremap r :<C-U>normal! `[v`]<CR>
onoremap p ap

" Unix mappings
noremap! <C-B> <Left>
noremap! <C-F> <Right>
noremap! <C-N> <Down>
noremap! <C-P> <Up>

" Fallbacks for things that were overriden earlier
nnoremap <expr> L "\<C-W>" . nr2char(getchar())
nnoremap <C-N> <C-I>
noremap <C-V> v

" Bang!
let g:bangmap = {
	\ 'b': 'b ',
	\ 'e': 'O ', 'E': "e!\n",
	\ 'v': 'vs|O ',
	\ 't': 'tabnew|O ',
	\ 'd': "cscope find g \<C-R>\<C-W>\n",
	\ 'h': 'vert help ',
	\ 'l': "'|redraw!\<Home>silent! grep '",
	\ 'q': "q\n", 'Q': "q!\n",
	\ 's': "source % | setlocal filetype=vim fileencoding=utf-8\nzx",
	\ 'W': "silent w !sudo tee % >/dev/null\n",
	\ '=': "\eVip:!perl -e '$r=qr/(?=\\Q\<C-R>=@/\n\\E)/;\\@l[map-/$r/g+pos,@_=<>];print s/$r/$\"x(@l-pos)/re for@_'\n",
	\ }
nnoremap <expr> ! ":\<C-U>" . get(g:bangmap, nr2char(getchar()), "\e")
