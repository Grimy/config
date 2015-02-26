function g
	git log --graph --all --date-order --date=short --pretty=format:'%C(yellow)%h %C(bold blue)%aN, %ad%Cgreen%d%Creset %<(80,trunc)%s' $argv
end
