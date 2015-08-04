function abort
	merge --abort 2>/dev/null
	rebase --abort 2>/dev/null
	cherry --abort 2>/dev/null
	bisect reset >/dev/null
end
