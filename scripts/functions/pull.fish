function pull
	if [ -z "$argv" ]
		set argv origin
	end
	fetch
	commit --allow-empty -qam 'tmp: rebase'
	and rebase $argv/(cb)
	and reset @^
end
