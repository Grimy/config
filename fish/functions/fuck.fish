function fuck
	if [ (count $argv) -gt 1 ]
		git checkout $argv
	else
		git reset --hard $argv
	end
end
