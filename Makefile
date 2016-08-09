tmp:
	for var in LEVEL{1_I,1_D,2_,3_}CACHE_{SIZE,LINESIZE,ASSOC}; do printf "%s:\t%s\n" "$$var" "$$(getconf $$var)"; done
