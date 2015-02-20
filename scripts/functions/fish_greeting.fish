function fish_greeting
	set -gx TERM          xterm-256color
	set -gx PATH          ~/bin $PATH
	set -gx LANG          en_US.UTF-8
	set -gx EDITOR        vim
	set -gx PAGER         'vim -'
	set -gx GCC_COLORS    'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
	set -gx NVIM_TUI_ENABLE_CURSOR_SHAPE 1
	set -gx FZF_DEFAULT_COMMAND 'ag -l -g ""'
	set -gx SSH_AUTH_SOCK /tmp/ssh-agent
	set -gx SSH_AGENT_PID (pidof ssh-agent)
	if [ -z $SSH_AGENT_PID ]
		ssh-agent -a $SSH_AUTH_SOCK >/dev/null
		ssh-add
	end
	echo -s "Howdy $USER, welcome to " (hostname) '!'
end
