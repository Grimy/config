function fish_prompt
	# echo -s (date '+%H:%M') ' ' (set_color $fish_color_cwd) (prompt_pwd) '> '
	printf '%s %s%s%s> ' (date '+%H:%M') (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

