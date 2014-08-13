compiler javac
set makeprg=make
nnoremap <buffer> !i mmb"tyegg/^package<CR>j:r! cat ~/.vim/cache/java/*<Bar>ag '/<C-R>t$'<Bar>sed 'y:/:.:;s:^:import :;s:$:;:'<CR>`m
