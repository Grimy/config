function c
	cd /tmp >/dev/null
	set CFLAGS $CFLAGS -xc -std=c99 -Wall -Wextra -pedantic -Werror -Wno-unused -march=native -g

	perl -le 'print for <#include<{string,std{lib,io}}.h>>' >tmp.c
	echo 'int main(void) {' >>tmp.c
	echo 'return 0; }' >>tmp.c

	while read -p 'echo "C> "' C
		if sed "\$i$C;" tmp.c | gcc $CFLAGS -
			printf "br %d\nr\np %s" (wc -l <tmp.c) $C |\
				gdb -q ./a.out 2>&1 | sed '/quit/Q; s/(gdb) $1 = //; s/(gdb) A syntax error.*/OK/; 1,8d'
			sed -i "\$i$C;" tmp.c
		end
	end
	cd -
end
