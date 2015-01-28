MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet
DIR = $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: vim
vim:
	mkdir -p cache/swaps cache/backups cache/undos
	-git clone https://github.com/neovim/neovim src
	cd src; git pull; make

.PHONY: symlinks
symlinks:
	ln -nsfv "$(DIR)/scripts/vim"            $(DIR)/../bin
	ln -nsfv "$(DIR)/scripts/.pentadactylrc" $(DIR)/../.pentadactylrc
	ln -nsfv "$(DIR)/scripts/.Xresources"    $(DIR)/../.Xresources
	ln -nsfv "$(DIR)/scripts/.gitconfig"     $(DIR)/../.gitconfig
	ln -nsfv "$(DIR)/scripts/functions"      $(DIR)/../.config/fish/functions
	ln -nsfv "$(DIR)/scripts/htop"           $(DIR)/../.config/htop
	ln -nsfv "$(DIR)/scripts/gvim.desktop"   $(DIR)/../.local/share/applications
