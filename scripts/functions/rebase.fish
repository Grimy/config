function rebase
	if [ -z "$argv" ]
		set argv origin/(cb)
	end
	git rebase $argv
end
