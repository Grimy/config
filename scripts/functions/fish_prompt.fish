function fish_prompt
	# Colored status indicator
	set s $status
	[ $s -ne 0 ]; and echo -ns (set_color red) "$s): "

	# Mail
	mail -e 2>&-; and echo -ns (set_color yellow) 'You’ve got mail! '

	# Current time
	echo -ns (set_color normal) (date '+%H:%M ') (set_color green)

	# Root indicator
	[ (id -u) -eq 0 ]; and echo -ns (set_color red) (hostname) ' '

	# Current directory
	echo -ns (prompt_pwd) (set_color normal) '> '

	# (set_color normal; echo -ne "\e[s\e[1;208f"; date '+%H:%M '; echo -ne "\e[u")
end
