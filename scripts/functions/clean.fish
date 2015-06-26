function clean
	du -sh "$argv"
	git --git-dir="$argv" reflog expire --expire-unreachable=now --all
	git --git-dir="$argv" repack -adfq --window=500 --window-memory=512m
	git --git-dir="$argv" gc --prune=now --quiet
	git --git-dir="$argv" fsck --unreachable --no-reflogs --no-progress
	du -sh "$argv"
end
