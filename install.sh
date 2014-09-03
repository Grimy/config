#!/bin/bash

basedir=$(dirname $(realpath $0))

cd "$basedir"
mkdir -p bundle cache/swaps cache/backups cache/undos
hg clone  https://vim.googlecode.com/hg/ src
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
	--enable-rubyinterp \
	# --enable-python3interp \

make

ln -nsfv "$basedir/src/src/vim"           ~/bin/
ln -nsfv "$basedir/scripts/.vimperatorrc" ~/.vimperatorrc
ln -nsfv "$basedir/scripts/.Xresources"   ~/.Xresources
ln -nsfv "$basedir/scripts/gvim.desktop"  ~/.local/share/applications
ln -nsfv "$basedir/scripts/.gitconfig"    ~/.gitconfig
ln -nsfv "$basedir/scripts/functions/"    ~/.config/fish/functions

src/vim -c 'PlugInstall!'
