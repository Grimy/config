function dus
	if [ -z "$argv" ]; set argv -c * .*; end
	du -sh $argv | sort -h
end
