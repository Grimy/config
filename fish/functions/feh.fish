function feh
	/bin/feh -FZ $argv 2>&1 | grep -v 'libpng warning' &
end
