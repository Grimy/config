#!/bin/sh

cd ~/.vim
mkdir -p bundle cache/swaps cache/backups cache/undos
git clone https://github.com/gmarik/vundle bundle/vundle
ln -s ~/.vim/powerline-fonts/ ~/.local/share/fonts
hg clone https://vim.googlecode.com/hg/ src

cd src
hg pull
hg update

./configure \
	--with-features=huge \
	--enable-multibyte \
	--enable-gui=gtk2 \
	--enable-rubyinterp \
	--enable-pythoninterp \
	--enable-python3interp \
	--enable-perlinterp \
	--enable-luainterp --with-lua-prefix=/usr --with-luajit \
	--enable-gpm \
	--enable-cscope \
	--enable-fontset \
	--enable-fail-if-missing

make

src/vim -c 'BundleInstall' -c 'qa'
cd ..

make -C bundle/vimproc
