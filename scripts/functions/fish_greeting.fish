function fish_greeting
	set -gx fish_new_pager 0

	set -gx TERM          xterm-256color
	set -gx PATH          ~/bin $PATH
	set -gx LANG          en_US.UTF-8
	set -gx EDITOR        vim
	set -gx PAGER         'vim -'
	set -gx GCC_COLORS    'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
	set -gx NVIM_TUI_ENABLE_CURSOR_SHAPE 1
	set -gx RUST_BACKTRACE 1
	set -gx FZF_DEFAULT_COMMAND 'ag -l -g ""'

	alias :q 'exit'
	alias add 'git add'
	alias amend 'git commit -v --amend --no-edit'
	alias branch 'git branch -f'
	alias cherry 'git cherry-pick'
	alias clone 'git clone'
	alias clop 'feh ~/p0'
	alias commit 'git commit -v'
	alias cp '/bin/cp -i'
	alias cpan 'sudo perl -MCPAN -e'
	alias diff 'git diff --patience'
	alias f 'find . -name'
	alias fetch 'git fetch --all --prune'
	alias fzf '/usr/bin/ruby ~/.nvim/bundle/fzf/fzf'
	alias gpg 'rlwrap gpg2 --expert'
	alias gs 'rlwrap gs'
	alias l 'git status -sb 2>/dev/null; or ll'
	alias ll 'ls -lAGh'
	alias mv '/bin/mv -i'
	alias nvim 'vim'
	alias pull 'git pull -u origin'
	alias push 'git push'
	alias rebase 'git rebase'
	alias remote 'git remote -v'
	alias stash 'git stash'
	alias stats 'git show --oneline --stat'
	alias tab 'gvim --remote-tab-silent'
	alias tag 'git tag -f'
	alias v 'vim'
	alias yay 'ponysay -f Fluttershy yay'

	echo -s "Howdy $USER, welcome to " (hostname) '!'
end
