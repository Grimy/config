function fish_greeting
	set -gx PATH     $PATH ~/bin
	set -gx LANG     en_US.UTF-8
	set -gx EDITOR   vim
	set -gx MANPAGER "vim -c 'setfiletype man' -"
	echo 'Howdy!'
end
