function del
	git branch -d $argv
	or git branch -D $argv
	or git tag -d $argv
end
