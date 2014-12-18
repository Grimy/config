PLUG += dag/vim-fish
PLUG += Grimy/dragonfly
PLUG += Grimy/indextrous
PLUG += Grimy/subliminal
PLUG += Grimy/vim-default-runtime
PLUG += Grimy/vim-rainbow
PLUG += junegunn/fzf
PLUG += junegunn/vim-easy-align
PLUG += junegunn/vim-fnr
PLUG += junegunn/vim-pseudocl
PLUG += klen/python-mode
PLUG += mbbill/undotree
PLUG += mmorearty/vim-matchit
PLUG += scrooloose/nerdcommenter
PLUG += scrooloose/nerdtree
PLUG += sukima/xmledit
PLUG += tpope/vim-endwise
PLUG += tpope/vim-fugitive
PLUG += tpope/vim-surround
PLUG += tpope/vim-unimpaired
PLUG += Valloric/YouCompleteMe
PLUG += vim-scripts/foldsearch

MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet --always-make --jobs

.PHONY: plug
plug: $(PLUG) $(wildcard *)

$(PLUG):
	[ -d $(notdir $@) ] || git clone https://github.com/$@

$(notdir $(PLUG)):
	cd $@ && git pull && vim +'helptags doc/' +q >/dev/null 2>&1

$(filter-out $(notdir $(PLUG)), $(wildcard *)):
	echo 'RM $@' && rm -rf $@

.PHONY: ycmd
ycmd:
	cd YouCompleteMe && git submodule update --init --recursive
	YouCompleteMe/third_party/ycmd/build.sh --clang-completer --system-libclang
