function co
	if [ -n "$argv" ]
		git checkout $argv
	else
		pr -tmw120 (git tag|psub) (git branch -a|psub)
	end
end
