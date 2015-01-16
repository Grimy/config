MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet

.ONESHELL:
.PHONY: vim
vim:
	mkdir -p bundle cache/swaps cache/backups cache/undos
	git clone https://github.com/neovim/neovim src
	cd src
	git pull
	make

.PHONY: symlinks
symlinks:
	ln -nsfv "/home/grimy/.vim/scripts/vim"            /home/grimy/bin
	ln -nsfv "/home/grimy/.vim/scripts/.pentadactylrc" /home/grimy/.pentadactylrc
	ln -nsfv "/home/grimy/.vim/scripts/.Xresources"    /home/grimy/.Xresources
	ln -nsfv "/home/grimy/.vim/scripts/gvim.desktop"   /home/grimy/.local/share/applications
	ln -nsfv "/home/grimy/.vim/scripts/.gitconfig"     /home/grimy/.gitconfig
	ln -nsfv "/home/grimy/.vim/scripts/functions"      /home/grimy/.config/fish/functions
	ln -nsfv "/home/grimy/.vim/scripts/htop"           /home/grimy/.config/htop
