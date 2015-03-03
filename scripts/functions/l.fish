function l
	ls -lAgh $argv
	git status -sb 2>/dev/null
end
