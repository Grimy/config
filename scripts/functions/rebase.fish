function rebase
	if [ -z "$argv" ]
		set argv --autostash origin/(cb)
	end
	git rebase $argv
end
