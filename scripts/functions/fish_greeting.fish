function fish_greeting
	set -gx PATH          $PATH ~/bin
	set -gx LANG          en_US.UTF-8
	set -gx EDITOR        vim
	set -gx MANPAGER      "vim -c 'setfiletype man' -"
	set -gx SSH_AUTH_SOCK /tmp/ssh-agent
	set -Ux SSH_AGENT_PID (pidof ssh-agent)
	if [ -z $SSH_AGENT_PID ]
		ssh-agent -a $SSH_AUTH_SOCK >/dev/null
		ssh-add
	end

	stty erase 

	echo 'Howdy!'
end
