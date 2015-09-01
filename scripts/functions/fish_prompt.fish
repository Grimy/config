function fish_prompt
	echo -ns \
		(set s $status; if [ $s -ne 0 ]; set_color red; echo "$s): "; end) \
		(set_color normal; date '+%H:%M ') \
		(if [ (id -u) -eq 0 ]; set_color red; hostname; echo ' '; end) \
		(set_color green; prompt_pwd; set_color normal; echo '> ')
		# (set_color normal; echo -ne "\e[s\e[1;208f"; date '+%H:%M '; echo -ne "\e[u")
end
