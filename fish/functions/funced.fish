function funced --description 'Edit function definition'
	[ (count $argv) -eq 1 ]; or return 1

	set -l path ~/.config/fish/functions/$argv.fish
	if [ ! -e $path ]
		if functions -q -- $argv
			functions -- $argv
		else
			echo function $argv\n\nend
		end > $path
	end
	eval $EDITOR $path
	and source $path
	return $status
end
