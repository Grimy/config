repos = $(wildcard *)

update: $(repos)

.PHONY: $(repos)
$(repos):
	@cd $@ 2>/dev/null && git pull && vim +'helptags doc/' +q >/dev/null 2>&1 || true

ycmd:
	cd YouCompleteMe && git submodule update --init --recursive
	YouCompleteMe/third_party/ycmd/build.sh --clang-completer --system-libclang
