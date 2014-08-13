function l
	ls -lAgh $argv
	git status 2>/dev/null
end
