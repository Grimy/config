function c
	cd /tmp >/dev/null
	set CCFLAGS $CCFLAGS -Wall -Wextra -Werror -Wno-unused -march=native -g -xc

	perl -le 'print for <#include<{string,std{lib,io}}.h>>' >tmp.c
	echo 'int main(void) {' >>tmp.c
	echo 'return 0; }' >>tmp.c

	while read -p 'echo "C> "' C
		if sed "\$i$C;" tmp.c | gcc $CCFLAGS -
			printf "br %d\nr\np %s" (wc -l <tmp.c) $C |\
				gdb -q ./a.out 2>&1 | sed '/quit/Q; s/.*= //; 1,6d'
			sed -i "\$i$C;" tmp.c
		end
	end
end
