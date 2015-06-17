function dus
	du -sbc * .* | sort -n | perl -pe 's;\d\K(\d{3})+\b;qw(k M G T P)[$&=~y///c/3-1];e'
end
