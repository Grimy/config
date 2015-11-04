function del
	git branch -D $argv
	or git tag -d $argv
end
