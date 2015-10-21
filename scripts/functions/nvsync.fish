function nvsync
	rsync -avzL --del --exclude={cache,spell,src,.netrwhist,'.git*','*.pyc',fzf,nvim} ~/.nvim/ "$argv":.nvim
	# ssh "$argv" ln -nsfv "~/.nvim/scripts/nvim-32"   "~/.nvim/scripts/nvim"
	# ssh "$argv" ln -nsfv "~/.nvim/scripts/functions" "~/.config/fish/functions"
	# ssh "$argv" ln -nsfv "~/.nvim/scripts/htop"      "~/.config/htop"
	# ssh "$argv" mkdir -p "~/.nvim/cache/{backups,swaps,undos}"
end
