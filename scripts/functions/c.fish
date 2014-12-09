function c
	echo "#include <stdlib.h>" > /tmp/tmp.c
	echo "#include <stdio.h>" >> /tmp/tmp.c
	echo "#include <string.h>" >> /tmp/tmp.c
	echo "int main(void) { $argv; return 0; }" >> /tmp/tmp.c
	gcc /tmp/tmp.c -Wall -Wextra -std=gnu99 -o /tmp/a.out
	/tmp/a.out
end
