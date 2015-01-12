MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet

.ONESHELL:
.PHONY: vim
vim:
	which hg || exit 'Requires mercurial'
	mkdir -p bundle cache/swaps cache/backups cache/undos
	hg clone https://vim.googlecode.com/hg/ src 2>/dev/null
	cd src
	hg pull
	hg update
	./configure --with-features=huge --enable-multibyte --enable-gui=gtk2 --enable-pythoninterp --enable-gpm --enable-cscope --enable-fontset --enable-fail-if-missing --enable-rubyinterp
	make

.PHONY: vimlog
vimlog:
	cd ~/.vim/src
	hg log -v -l 32 | perl -ne '/Problem/../^$$/ and print'

.PHONY: symlinks
symlinks:
	ln -nsfv "/home/grimy/.vim/src/src/vim"            /home/grimy/bin/
	ln -nsfv "/home/grimy/.vim/scripts/.pentadactylrc" /home/grimy/.pentadactylrc
	ln -nsfv "/home/grimy/.vim/scripts/.Xresources"    /home/grimy/.Xresources
	ln -nsfv "/home/grimy/.vim/scripts/gvim.desktop"   /home/grimy/.local/share/applications
	ln -nsfv "/home/grimy/.vim/scripts/.gitconfig"     /home/grimy/.gitconfig
	ln -nsfv "/home/grimy/.vim/scripts/functions"      /home/grimy/.config/fish/functions
	ln -nsfv "/home/grimy/.vim/scripts/htop"           /home/grimy/.config/htop
