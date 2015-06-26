function nvsync
	rsync -avzL --del --exclude={cache,spell,src,.netrwhist,'.git*','*.pyc',fzf} ~/.nvim/ "$argv":.nvim
	rsync -avzL --include={src,build,bin,nvim-32} --exclude='*' ~/.nvim/ "$argv":.nvim
	# ssh "$argv" ln -nsfv "~/.nvim/scripts/functions" "~/.config/fish/functions"
	# ssh "$argv" ln -nsfv "~/.nvim/scripts/htop"      "~/.config/htop"
	# ssh "$argv" mkdir -p "~/.nvim/cache/{backups,swaps,undos}"
end
