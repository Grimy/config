PLUG += ervandew/eclim
PLUG += Grimy/dragonfly
PLUG += Grimy/indextrous
PLUG += Grimy/subliminal
PLUG += junegunn/fzf
PLUG += junegunn/vim-easy-align
PLUG += junegunn/vim-pseudocl
PLUG += klen/python-mode
PLUG += mbbill/undotree
PLUG += tpope/vim-fugitive
PLUG += Valloric/YouCompleteMe

MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet --always-make --jobs

.PHONY: plug
plug: $(PLUG) $(wildcard *)

$(PLUG):
	[ -d $(notdir $@) ] || git clone https://github.com/$@

$(notdir $(PLUG)):
	- cd $@ && git pull && vim +'helptags doc/' +q >/dev/null 2>&1

$(filter-out $(notdir $(PLUG)), $(wildcard *)):
	echo 'RM $@' && rm -rf $@

.PHONY: ycmd
ycmd:
	cd YouCompleteMe && git submodule update --init --recursive
	YouCompleteMe/third_party/ycmd/build.py --clang-completer --system-libclang
