function nvsync
	rsync -avzL --del --exclude={cache,spell,src,.netrwhist,'.git*','*.pyc',fzf} ~/.nvim/ "$argv":.nvim
end
