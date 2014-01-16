#!/bin/sh

ln -s ~/.vim/scripts/.vimperatorrc ~/.vimperatorrc
ln -s ~/.vim/scripts/.Xresources   ~/.Xresources
ln -s ~/.vim/scripts/.gitconfig    ~/.gitconfig
ln -s ~/.vim/scripts/.vimperatorrc ~/.vimperatorrc
ln -s ~/.vim/scripts/functions/    ~/.config/fish/functions/
ln -s ~/.vim/powerline-fonts/      ~/.local/share/fonts
fc-cache -rv

cd ~/.vim
mkdir -p bundle cache/swaps cache/backups cache/undos
git clone https://github.com/gmarik/vundle bundle/vundle
hg clone https://vim.googlecode.com/hg/ src

cd src
hg pull
hg update

./configure \
	--with-features=huge \
	--enable-multibyte \
	--enable-gui=gtk2 \
	--enable-perlinterp \
	# --enable-rubyinterp \
	--enable-pythoninterp \
	# --enable-python3interp \
	--enable-luainterp --with-lua-prefix=/usr --with-luajit \
	--enable-gpm \
	--enable-cscope \
	--enable-fontset \
	--enable-fail-if-missing

make

src/vim -c 'BundleInstall' -c 'qa'
cd ..

make -C bundle/vimproc
