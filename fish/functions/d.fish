function d
	gdb -q -ex 'set confirm off' -ex 'b main' -ex "r $argv" (find debug/* -not -name '*.*')
end
