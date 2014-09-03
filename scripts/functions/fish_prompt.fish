function fish_prompt
	set -l color (perl -e 'print $< ? green : red')
	echo -ns (date '+%H:%M ') (set_color $color) (prompt_pwd) (set_color normal) '> '
end
