function fish_prompt
	# Colored status indicator
	or echo -ens "\e[31m($status) "

	# Mail
	mail -e 2>&-; and echo -ens '\e[33mYou’ve got mail! '

	# Current time
	echo -ens '\e[m' (date '+%H:%M ') '\e[92m'

	# Root indicator
	[ (id -u) -eq 0 ]; and echo -ens '\e[31m' (hostname) ' '

	# Current directory
	echo -ens (prompt_pwd) '\e[m> '

	# (set_color normal; echo -ne "\e[s\e[1;208f"; date '+%H:%M '; echo -ne "\e[u")
end
