function nvsync
	rsync -avzL --del --exclude={cache,spell,src,.netrwhist,'.git*','*.pyc',fzf} . "$argv":.nvim
end
