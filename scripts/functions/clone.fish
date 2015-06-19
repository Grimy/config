function clone
	git clone $argv
	cd (basename $argv)
end
