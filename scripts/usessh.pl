#!/usr/bin/perl

my $base = '/home/grimy/.vim';
chdir $base;

for my $dir ('', <bundle/*>) {
	chdir "$base/$dir";
	$_ = `git ls-remote --get-url origin`;
	print;
	s/http\K.*(?=(Grimy.*))/s:\/\/github.com\//
	&& print("Setting $1 to use ssh\n")
	&& `git remote add https $_`;
}
