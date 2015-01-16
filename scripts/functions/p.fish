function p
	set PERF_EVENTS -etask-clock -epage-faults -ecycles -einstructions -ebranch -ebranch-misses
	perf stat -d $PERF_EVENTS (find bin/* -not -name '*.*') $argv
end
