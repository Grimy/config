# sudo yum -y install autoconf automake cmake gcc gcc-c++ libtool pkgconfig
# sudo pacman -S base-devel cmake unzip

MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet
DIR = $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: nvim
nvim:
	mkdir -p ~/.local/share/nvim/{undo,backup}
	-git clone https://github.com/neovim/neovim src
	cd src; git pull; make
	nvim +'helptags doc' +q >/dev/null 2>&1

.PHONY: symlinks
symlinks:
	ln -nsfv "$(DIR)/src/runtime/doc"        "$(DIR)/doc"
	ln -nsfv "$(DIR)/src/runtime/autoload"   "$(DIR)/autoload"
	ln -nsfv "$(DIR)/src/runtime/compiler"   "$(DIR)/compiler"
