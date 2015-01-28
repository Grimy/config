function fish_prompt
	echo -ns (date '+%H:%M ') (if [ (id -u) -eq 0 ]
		set_color red
		hostname
	else
		set_color green
	end) (prompt_pwd) (set_color normal) '> '
end
