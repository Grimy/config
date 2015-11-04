function g
	if [ -z "$argv" ]
		set argv --all
	end
	set format '%C(yellow)%h %C(bold blue)%aN, %ad%Cgreen%d%Creset %<(80,trunc)%s'
	git log --graph --topo-order --date=short --pretty=format:$format $argv
end
