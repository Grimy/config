function pull
	if [ -z "$argv" ]
		set argv origin
	end
	fetch "$argv"
	and git merge --ff-only "$argv"/(cb)
end
