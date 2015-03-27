# sudo yum -y install autoconf automake cmake gcc gcc-c++ libtool pkgconfig
# sudo pacman -S base-devel cmake unzip

MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet
DIR = $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: vim
vim:
	mkdir -p cache/swaps cache/backups cache/undos
	-git clone https://github.com/neovim/neovim src
	cd src; git pull; make
	vim +'helptags doc/' +q >/dev/null 2>&1

.PHONY: symlinks
symlinks:
	ln -nsfv "$(DIR)/scripts/vim"            "$(DIR)/../bin"
	ln -nsfv "$(DIR)/scripts/.pentadactylrc" "$(DIR)/../.pentadactylrc"
	ln -nsfv "$(DIR)/scripts/.Xresources"    "$(DIR)/../.Xresources"
	ln -nsfv "$(DIR)/scripts/.gitconfig"     "$(DIR)/../.gitconfig"
	ln -nsfv "$(DIR)/scripts/functions"      "$(DIR)/../.config/fish/functions"
	ln -nsfv "$(DIR)/scripts/htop"           "$(DIR)/../.config/htop"
	ln -nsfv "$(DIR)/scripts/gvim.desktop"   "$(DIR)/../.local/share/applications"
	ln -nsfv "$(DIR)/src/runtime/doc"        "$(DIR)/doc"
	ln -nsfv "$(DIR)/src/runtime/autoload"   "$(DIR)/autoload"
	ln -nsfv "$(DIR)/src/runtime/compiler"   "$(DIR)/compiler"

