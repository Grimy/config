function v
	if [ -z "$argv" ]
		set argv .
	end
	vim $argv
end
