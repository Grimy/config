function ff
	if [ -z "$argv" ]
		set argv origin/(cb)
	end
	git merge --ff-only "$argv"
end

