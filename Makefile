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
	./configure \
		--with-features=huge \
		--enable-multibyte \
		--enable-gui=gtk2 \
		--enable-perlinterp \
		--enable-pythoninterp \
		--enable-luainterp --with-lua-prefix=/usr --with-luajit \
		--enable-gpm \
		--enable-cscope \
		--enable-fontset \
		--enable-fail-if-missing \
		--enable-rubyinterp
	make

.PHONY: vimlog
vimlog:
	cd ~/.vim/src
	hg log -v -l 32 | perl -ne '/Problem/../^$$/ and print'

.PHONY: symlinks
symlinks:
	ln -nsfv "~/.vim/src/src/vim"            ~/bin/
	ln -nsfv "~/.vim/scripts/.pentadactylrc" ~/.pentadactylrc
	ln -nsfv "~/.vim/scripts/.Xresources"    ~/.Xresources
	ln -nsfv "~/.vim/scripts/gvim.desktop"   ~/.local/share/applications
	ln -nsfv "~/.vim/scripts/.gitconfig"     ~/.gitconfig
	ln -nsfv "~/.vim/scripts/functions"      ~/.config/fish/functions
	ln -nsfv "~/.vim/scripts/htop"           ~/.config/htop
