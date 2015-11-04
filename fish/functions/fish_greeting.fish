function fish_greeting
	set -gx fish_new_pager 0
	set -gx TERM          xterm-256color
	set -gx LANG          en_US.UTF-8
	set -gx EDITOR        vim
	set -gx GCC_COLORS    'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
	set -gx NVIM_TUI_ENABLE_CURSOR_SHAPE 1
	set -gx RUST_BACKTRACE 1
	set -gx FZF_DEFAULT_COMMAND 'ag -l -g ""'

	set -gx XDG_CONFIG_HOME ~/.config
	set -gx PATH ~/bin $XDG_CONFIG_HOME/bin {,/usr}/*bin /usr/local/bin
	set -gx PENTADACTYL_RUNTIME "$XDG_CONFIG_HOME/pentadactyl"
	set -gx PENTADACTYL_INIT ":source $PENTADACTYL_RUNTIME/init"

	alias :q 'exit'
	alias add 'git add'
	alias amend 'git commit -v --amend --no-edit'
	alias bisect 'git bisect'
	alias branch 'git branch -f'
	alias cherry 'git cherry-pick'
	alias clone 'git clone'
	alias clop 'feh ~/p0'
	alias commit 'git commit -v'
	alias cp '/bin/cp -i'
	alias cpan 'sudo perl -MCPAN -e'
	alias diff 'git diff --patience'
	alias dnf 'sudo dnf'
	alias dnfy 'sudo dnf install -y'
	alias f 'find . -name'
	alias fzf '/usr/bin/ruby ~/.nvim/bundle/fzf/fzf'
	alias gpg 'rlwrap gpg2 --expert'
	alias gs 'rlwrap gs'
	alias gsql 'ssh gerrit gerrit gsql'
	alias l 'ls -GAhl'
	alias ll 'ls -GAhl'
	alias mv '/bin/mv -i'
	alias push 'git push'
	alias reflog 'git reflog'
	alias remote 'git remote -v'
	alias s 'git status -sb'
	alias show 'git show'
	alias stash 'git stash'
	alias stats 'git show --oneline --stat'
	alias tab 'gvim --remote-tab-silent'
	alias tag 'git tag -f'
	alias v "nvim -O"
	alias vim "nvim -O"
	alias yay 'ponysay -f Fluttershy yay'

	echo -s "Howdy $USER, welcome to " (hostname) '!'
	cd >/dev/null
end
