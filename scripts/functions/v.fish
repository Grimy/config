function v
	if [ -n "$argv" ]
		vim $argv
	else
		ranger
	end
end
