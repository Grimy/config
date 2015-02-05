augroup Network
 au!
 au BufReadCmd   file://*									call netrw#FileUrlRead(expand("<amatch>"))
 au BufReadCmd   ftp://*,rcp://*,scp://*,http://*,https://*,dav://*,davs://*,rsync://*,sftp://*	exe "sil doau BufReadPre ".fnameescape(expand("<amatch>"))|call netrw#Nread(2,expand("<amatch>"))|exe "sil doau BufReadPost ".fnameescape(expand("<amatch>"))
 au FileReadCmd  ftp://*,rcp://*,scp://*,http://*,https://*,dav://*,davs://*,rsync://*,sftp://*	exe "sil doau FileReadPre ".fnameescape(expand("<amatch>"))|call netrw#Nread(1,expand("<amatch>"))|exe "sil doau FileReadPost ".fnameescape(expand("<amatch>"))
 au BufWriteCmd  ftp://*,rcp://*,scp://*,dav://*,davs://*,rsync://*,sftp://*			exe "sil doau BufWritePre ".fnameescape(expand("<amatch>"))|exe 'Nwrite '.fnameescape(expand("<amatch>"))|exe "sil doau BufWritePost ".fnameescape(expand("<amatch>"))
 au FileWriteCmd ftp://*,rcp://*,scp://*,dav://*,davs://*,rsync://*,sftp://*			exe "sil doau FileWritePre ".fnameescape(expand("<amatch>"))|exe "'[,']".'Nwrite '.fnameescape(expand("<amatch>"))|exe "sil doau FileWritePost ".fnameescape(expand("<amatch>"))
 try
  au SourceCmd   ftp://*,rcp://*,scp://*,http://*,https://*,dav://*,davs://*,rsync://*,sftp://*	exe 'Nsource '.fnameescape(expand("<amatch>"))
 catch /^Vim\%((\a\+)\)\=:E216/
  au SourcePre   ftp://*,rcp://*,scp://*,http://*,https://*,dav://*,davs://*,rsync://*,sftp://*	exe 'Nsource '.fnameescape(expand("<amatch>"))
 endtry
augroup END

com! -count=1 -nargs=*	Nread		call netrw#NetrwSavePosn()<bar>call netrw#NetRead(<count>,<f-args>)<bar>call netrw#NetrwRestorePosn()
com! -range=% -nargs=*	Nwrite		call netrw#NetrwSavePosn()<bar><line1>,<line2>call netrw#NetWrite(<f-args>)<bar>call netrw#NetrwRestorePosn()
com! -nargs=*		NetUserPass	call NetUserPass(<f-args>)
com! -nargs=*	        Nsource		call netrw#NetrwSavePosn()<bar>call netrw#NetSource(<f-args>)<bar>call netrw#NetrwRestorePosn()

com! -nargs=* -bar -bang -count=0 -complete=dir	Explore		call netrw#Explore(<count>,0,0+<bang>0,<q-args>)
com! -nargs=* -bar -bang -count=0 -complete=dir	Sexplore	call netrw#Explore(<count>,1,0+<bang>0,<q-args>)
com! -nargs=* -bar -bang -count=0 -complete=dir	Hexplore	call netrw#Explore(<count>,1,2+<bang>0,<q-args>)
com! -nargs=* -bar -bang -count=0 -complete=dir	Vexplore	call netrw#Explore(<count>,1,4+<bang>0,<q-args>)
com! -nargs=* -bar       -count=0 -complete=dir	Texplore	call netrw#Explore(<count>,0,6        ,<q-args>)
com! -nargs=* -bar -bang			Nexplore	call netrw#Explore(-1,0,0,<q-args>)
com! -nargs=* -bar -bang			Pexplore	call netrw#Explore(-2,0,0,<q-args>)

com! -nargs=0	NetrwSettings	call netrwSettings#NetrwSettings()
com! -bang	NetrwClean	call netrw#NetrwClean(<bang>0)

" Maps:
if !exists("g:netrw_nogx") && maparg('gx','n') == ""
 if !hasmapto('<Plug>NetrwBrowseX')
  nmap <unique> gx <Plug>NetrwBrowseX
 endif
 nno <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)<cr>
endif

" ---------------------------------------------------------------------
"   Usage:  :call NetUserPass()			-- will prompt for userid and password
"	    :call NetUserPass("uid")		-- will prompt for password
"	    :call NetUserPass("uid","password") -- sets global userid and password
fun! NetUserPass(...)

 " get/set userid
 if a:0 == 0
  if !exists("g:netrw_uid") || g:netrw_uid == ""
   " via prompt
   let g:netrw_uid= input('Enter username: ')
  endif
 else	" from command line
  let g:netrw_uid= a:1
 endif

 " get password
 if a:0 <= 1 " via prompt
  let g:netrw_passwd= inputsecret("Enter Password: ")
 else " from command line
  let g:netrw_passwd=a:2
 endif
endfun

" ------------------------------------------------------------------------
" vinegar.vim - combine with netrw to create a delicious salad dressing
" Maintainer:   Tim Pope <http://tpo.pe/>

function! s:fnameescape(file) abort
  if exists('*fnameescape')
    return fnameescape(a:file)
  else
    return escape(a:file," \t\n*?[{`$\\%#'\"|!<")
  endif
endfunction

let s:dotfiles = '\(^\|\s\s\)\zs\.\S\+'

let g:netrw_sort_sequence = '[\/]$,*,\%(' . join(map(split(&suffixes, ','), 'escape(v:val, ".*$~")'), '\|') . '\)[*@]\=$'
let s:escape = 'substitute(escape(v:val, ".$~"), "*", ".*", "g")'
let g:netrw_list_hide =
      \ join(map(split(&wildignore, ','), '"^".' . s:escape . '. "$"'), ',') . ',^\.\.\=/\=$' .
      \ (get(g:, 'netrw_list_hide', '')[-strlen(s:dotfiles)-1:-1] ==# s:dotfiles ? ','.s:dotfiles : '')
let g:netrw_banner = 0
let s:netrw_up = ''

function! s:opendir(cmd)
  let df = ','.s:dotfiles
  if expand('%:t')[0] ==# '.' && g:netrw_list_hide[-strlen(df):-1] ==# df
    let g:netrw_list_hide = g:netrw_list_hide[0 : -strlen(df)-1]
  endif
  if &filetype ==# 'netrw'
    let currdir = fnamemodify(b:netrw_curdir, ':t')
    execute s:netrw_up
    call s:seek(currdir)
  else
    if empty(expand('%'))
      execute a:cmd '.'
    else
      execute a:cmd '%:h/'
      call s:seek(expand('#:t'))
    endif
  endif
endfunction

function! s:seek(file)
  let pattern = '^\%(| \)*'.escape(a:file, '.*[]~\').'[/*|@=]\=\%($\|\t\)'
  call search(pattern, 'wc')
  return pattern
endfunction

function! s:escaped(first, last) abort
  let files = getline(a:first, a:last)
  call filter(files, 'v:val !~# "^\" "')
  call map(files, 'substitute(v:val, "[/*|@=]\\=\\%(\\t.*\\)\\=$", "", "")')
  return join(map(files, 'fnamemodify(b:netrw_curdir."/".v:val,":~:.")'), ' ')
endfunction

function! g:SetupVinegar() abort
  if empty(s:netrw_up)
    " save netrw mapping
    let s:netrw_up = maparg('-', 'n')
    " saved string is like this:
    " :exe "norm! 0"|call netrw#LocalBrowseCheck(<SNR>172_NetrwBrowseChgDir(1,'../'))<CR>
    " remove <CR> at the end (otherwise raises "E488: Trailing characters")
    let s:netrw_up = strpart(s:netrw_up, 0, strlen(s:netrw_up)-4)
  endif
  nnoremap <buffer> ~ :edit ~/<CR>
  nnoremap <buffer> . :<C-U> <C-R>=<SID>escaped(line('.'), line('.') - 1 + v:count1)<CR><Home>
  xnoremap <buffer> . <Esc>: <C-R>=<SID>escaped(line("'<"), line("'>"))<CR><Home>
  exe 'syn match SpecialKey =\%(\S\+ \)*\S\+\%('.join(map(split(&suffixes, ','), s:escape), '\|') . '\)[*@]\=\S\@!='
endfunction
