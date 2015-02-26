function co
	if [ -n "$argv" ]
		git checkout $argv
	else
		pr -tmw120 (git branch -a|psub) (git tag|psub)
	end
end
