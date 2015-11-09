# sudo yum -y install autoconf automake cmake gcc gcc-c++ libtool pkgconfig
# sudo pacman -S base-devel cmake unzip

MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet

.PHONY: all
all:
	mkdir -p ~/.local/share/nvim/{undo,backup,swap}
	-git clone https://github.com/neovim/neovim src
	cd src; git pull
	mkdir -p ~/.local/share/nvim/undo
	ln -nsfv "src/runtime/doc"        .
	ln -nsfv "src/runtime/autoload"   .
	ln -nsfv "src/runtime/compiler"   .
	nvim +'helptags doc' +q >/dev/null 2>&1
