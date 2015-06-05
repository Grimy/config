PLUG += benekastah/neomake
PLUG += ervandew/eclim
PLUG += Grimy/dragonfly
PLUG += Grimy/indextrous
PLUG += Grimy/subliminal
PLUG += junegunn/fzf
PLUG += junegunn/vim-easy-align
PLUG += junegunn/vim-pseudocl
PLUG += mbbill/undotree

MAKEFLAGS += --no-builtin-rules --no-builtin-vars --quiet --always-make --jobs

.PHONY: plug
plug: $(PLUG) $(wildcard *)

$(PLUG):
	[ -d $(notdir $@) ] || git clone https://github.com/$@

$(notdir $(PLUG)):
	- cd $@ && (git pull || echo $@) && vim +'helptags doc/' +q >/dev/null 2>&1

$(filter-out $(notdir $(PLUG)), $(wildcard *)):
	echo 'RM $@' && rm -rf $@

.PHONY: ycmd
ycmd:
	- rm YouCompleteMe/third_party/ycmd/third_party/sh/sh.pyc
	cd YouCompleteMe && git pull && git submodule update --init --recursive
	YouCompleteMe/third_party/ycmd/build.py --clang-completer --system-libclang
