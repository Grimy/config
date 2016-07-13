MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet

.PHONY: vint
vint:
	vint -s init.vim plugin/*.vim syntax/*.vim

.PHONY: all
.ONESHELL:

all:
	mkdir -p '$(XDG_DATA_HOME)'/vim/{undo,backup,swap}
	# git clone https://github.com/vim/vim src || (cd src; git pull)
	cd src
	git clean -dix
	export CFLAGS='-m32 -O2 -DFEAT_CLIPBOARD -DFEAT_XCLIPBOARD'
	./configure --with-features=huge
	make
	ln -nsfv src/runtime/doc .
	vim -u NONE +'helptags doc' +q
