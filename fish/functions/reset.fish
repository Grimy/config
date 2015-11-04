function reset
	if [ -n "$argv" ]
		git reset $argv
	else
		eval (which reset)
	end
end
