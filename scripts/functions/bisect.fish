function bisect
	git bisect start HEAD $argv[1]
	git bisect run $argv[2..-1]
end
