#!/bin/bash

basedir=$(dirname $(realpath $0))
echo $basedir
exit

ln -s "$basedir/scripts/.vimperatorrc" ~/.vimperatorrc
ln -s "$basedir/scripts/.Xresources"   ~/.Xresources
ln -s "$basedir/scripts/.gitconfig"    ~/.gitconfig
ln -s "$basedir/scripts/.vimperatorrc" ~/.vimperatorrc
ln -s "$basedir/scripts/functions/"    ~/.config/fish/functions/
ln -s "$basedir/scripts/grim"          ~/bin/grim
ln -s "$basedir/powerline-fonts/"      ~/.local/share/fonts/     && fc-cache -r

cd "$basedir"
mkdir -p bundle cache/swaps cache/backups cache/undos
git clone https://github.com/gmarik/vundle bundle/vundle
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
	# --enable-rubyinterp \
	# --enable-python3interp \

make

src/vim -c 'BundleInstall!' -c 'qa'

make -C ../bundle/vimproc
