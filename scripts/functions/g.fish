function g
	set commits --branches --tags --remotes HEAD
	set format '%C(yellow)%h %C(bold blue)%aN, %ad%Cgreen%d%Creset %<(80,trunc)%s'
	git log --graph --date-order --date=short --pretty=format:$format $commits $argv
end
