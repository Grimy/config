function fetch
	if [ -z "$argv" ]
		set argv --all
	end
	git fetch --prune $argv
end
