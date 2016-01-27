 let g:zipPlugin_ext = '*.zip,*.jar,*.xpi,*.ja,*.war,*.ear,*.celzip,*.oxt,*.kmz,*.wsz,*.xap,*.docx,*.docm,*.dotx,*.dotm,*.potx,*.potm,*.ppsx,*.ppsm,*.pptx,*.pptm,*.ppam,*.sldx,*.thmx,*.xlam,*.xlsx,*.xlsm,*.xlsb,*.xltx,*.xltm,*.xlam,*.crtx,*.vdw,*.glox,*.gcsx,*.gqsx'

augroup zip
	autocmd BufReadPre,FileReadPre     *.gz,*.bz2,*.Z,*.lzma,*.xz setlocal bin
	autocmd BufReadPost,FileReadPost   *.gz   call gzip#read("gzip -dn")
	autocmd BufReadPost,FileReadPost   *.bz2  call gzip#read('bzip2 -d')
	autocmd BufReadPost,FileReadPost   *.Z    call gzip#read('uncompress')
	autocmd BufReadPost,FileReadPost   *.lzma call gzip#read('lzma -d')
	autocmd BufReadPost,FileReadPost   *.xz   call gzip#read('xz -d')
	autocmd BufWritePost,FileWritePost *.gz   call gzip#write('gzip')
	autocmd BufWritePost,FileWritePost *.bz2  call gzip#write('bzip2')
	autocmd BufWritePost,FileWritePost *.Z    call gzip#write('compress -f')
	autocmd BufWritePost,FileWritePost *.lzma call gzip#write('lzma -z')
	autocmd BufWritePost,FileWritePost *.xz   call gzip#write('xz -z')
	autocmd FileAppendPre              *.gz   call gzip#appre('gzip -dn')
	autocmd FileAppendPre              *.bz2  call gzip#appre('bzip2 -d')
	autocmd FileAppendPre              *.Z    call gzip#appre('uncompress')
	autocmd FileAppendPre              *.lzma call gzip#appre('lzma -d')
	autocmd FileAppendPre              *.xz   call gzip#appre('xz -d')
	autocmd FileAppendPost             *.gz   call gzip#write('gzip')
	autocmd FileAppendPost             *.bz2  call gzip#write('bzip2')
	autocmd FileAppendPost             *.Z    call gzip#write('compress -f')
	autocmd FileAppendPost             *.lzma call gzip#write('lzma -z')
	autocmd FileAppendPost             *.xz   call gzip#write('xz -z')
	autocmd BufReadCmd   zipfile:*   call zip#Read(expand('<amatch>'), 1)
	autocmd FileReadCmd  zipfile:*   call zip#Read(expand('<amatch>'), 0)
	autocmd BufWriteCmd  zipfile:*   call zip#Write(expand('<amatch>'))
	autocmd FileWriteCmd zipfile:*   call zip#Write(expand('<amatch>'))
	autocmd BufReadCmd   zipfile:*/* call zip#Read(expand('<amatch>'), 1)
	autocmd FileReadCmd  zipfile:*/* call zip#Read(expand('<amatch>'), 0)
	autocmd BufWriteCmd  zipfile:*/* call zip#Write(expand('<amatch>'))
	autocmd FileWriteCmd zipfile:*/* call zip#Write(expand('<amatch>'))
	exe 'autocmd         BufReadCmd  '.g:zipPlugin_ext.' call zip#Browse(expand("<amatch>"))'
augroup END
