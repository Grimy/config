function fish_prompt
	echo -ns (date '+%H:%M ') (set_color green) (if [ (id -u) -eq 0 ]
		set_color red
		hostname
		echo -n ' '
	end) (prompt_pwd) (set_color normal) '> '
end
