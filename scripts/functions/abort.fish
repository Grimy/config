function abort
	merge --abort 2>/dev/null
	or rebase --abort 2>/dev/null
	or cherry --abort 2>/dev/null
	or echo Nothing to abort
end
