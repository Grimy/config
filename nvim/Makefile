MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet

.PHONY: vint
vint:
	vint -s init.vim plugin/*.vim syntax/*.vim

.PHONE: all
all:
	mkdir -p '$(XDG_DATA_HOME)'/nvim/{undo,backup,swap}
	git clone https://github.com/neovim/neovim src || (cd src; git pull)
	ln -nsfv "src/runtime/doc"        .
	ln -nsfv "src/runtime/autoload"   .
	nvim -u NONE --headless +'helptags doc' +q
