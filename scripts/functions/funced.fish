function funced --description 'Edit function definition'
	if test (count $argv) -ne 1
		set_color red
		_ "funced: You must specify one function name"
		set_color normal
		return 1
	end
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
