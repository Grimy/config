function merge
	git merge --no-ff $argv
	and git branch -d $argv
end
