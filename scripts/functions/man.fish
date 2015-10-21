function man --description 'Format and display the on-line manual pages'
	command man -w $argv >/dev/null
	and command man -Pcat $argv | vim -
end
