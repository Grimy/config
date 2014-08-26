function fish_user_key_bindings
	bind \cp   up-or-search
	bind \cn down-or-search

	# Ctrl + arrow keys
	bind \e\[1\;5A history-token-search-backward
	bind \e\[1\;5B history-token-search-forward
	bind \e\[1\;5C nextd-or-forward-word
	bind \e\[1\;5D prevd-or-backward-word

	# Ctrl-Del and Ctrl-Backspace
	bind \e\[3\;5~ kill-word
	bind \e\[3^    kill-word
	# bind \e\[\? backward-kill-word

	bind \e\[25~ null
	bind \e\[26~ null
end
fzf_key_bindings
